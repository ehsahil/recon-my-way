#!/usr/bin/env ruby

# == Bucket Finder - Trawl Amazon S3 buckets for interesting files
#
# Each group of files on Amazon S3 have to be contained in a bucket and each bucket has to have a unique
# name across the system. This means that it is possible to bruteforce names, this script does this and more
#
# For more information on how this works see my blog post "Whats in Amazon's buckets?" at
#   http://www.digininja.org/blog/whats_in_amazons_buckets.php
#
# == Version
#
#  1.0 - Released
#  1.1 - Added log to file option
#
# == Usage
#
# bucket_finder.rb <wordlist>
#
# -l, --log-file <file name>:
#   filename to log output to
# -d, --download:
# 	download any public files found
# -r, --region:
# 	specify the start region
# -h, --help:
#	show help
#
# <wordlist>: the names to brute force
#
# Author:: Robin Wood (robin@digininja.org
# Copyright:: Copyright (c) Robin Wood 2011
# Licence:: Creative Commons Attribution-Share Alike Licence
#

require 'rexml/document'
require 'net/http'
require 'uri'
require 'getoptlong'
require 'fileutils'

# This is needed because the standard parse can't handle square brackets
# so this encodes them before parsing
module URI
  class << self

    def parse_with_safety(uri)
      parse_without_safety uri.gsub('[', '%5B').gsub(']', '%5D')
    end

    alias parse_without_safety parse
    alias parse parse_with_safety
  end
end

# Display the usage
def usage
	puts"bucket_finder 1.0 Robin Wood (robin@digininja.org) (www.digininja.org)

Usage: bucket_finder [OPTION] ... wordlist
	--help, -h: show help
	--download, -d: download the files
	--log-file, -l: filename to log output to
	--region, -r: the region to use, options are:
					us - US Standard
					ie - Ireland
					nc - Northern California
					si - Singapore
					to - Tokyo
	-v: verbose

	wordlist: the wordlist to use

"
	exit
end

def get_page host, page
	url = URI.parse(host)

	begin
		res = Net::HTTP.start(url.host, url.port) {|http|
			http.get("/" + page)
		}
	rescue Timeout::Error
		puts "Timeout"
		@logging.puts "Timeout" unless @logging.nil?
		return ''
	rescue => e
		puts "Error requesting page: " + e.to_s
		@logging.puts "Error requesting page: " + e.to_s unless @logging.nil?
		return ''
	end

	return res.body
end

def parse_results doc, bucket_name, host, download, depth = 0
	tabs = ''

	depth.times {
		tabs += "\t"
	}

	if !doc.elements['ListBucketResult'].nil?
		puts tabs + "Bucket Found: " + bucket_name + " ( " + host + "/" + bucket_name + " )"
		@logging.puts tabs + "Bucket Found: " + bucket_name + " ( " + host + "/" + bucket_name + " )" unless @logging.nil?
		doc.elements.each('ListBucketResult/Contents') do |ele|
			protocol = ''
			dir = bucket_name + '/'
			if host !~ /^http/
				protocol = 'http://'
				dir = ''
			end
			filename = ele.elements['Key'].text
			url = protocol + host + '/' + dir + URI.escape(filename)

			response = nil
			parsed_url = URI.parse(url)
			downloaded = false
			readable = false

			# the directory listing contains directory names as well as files
			# so if a filename ends in a / then it is actually a directory name
			# so don't try to download it
			if download and filename != '' and filename[-1].chr != '/'
				fs_dir = File.dirname(URI.parse(url).path)[1..-1]

				# If the depth is 0 then it is top level and the bucket name is the first part of the directory
				# If it is greater than 0 then we've done a redirection to the path runs from / so we need to
				# manually add the bucket name on
				if depth > 0
					fs_dir = bucket_name + '/' + fs_dir
				end
				if !File.exists? fs_dir
					FileUtils.mkdir_p fs_dir
				end

				Net::HTTP.start(parsed_url.host, parsed_url.port) {|http|
					response = http.get(parsed_url.path)
					if response.code.to_i == 200
						open(fs_dir + '/' + File.basename(filename), 'wb') { |file|
							file.write(response.body)
						}
						downloaded = true
						readable = true
					else
						readable = false
						downloaded = false
					end
				}
			else
				Net::HTTP.start(parsed_url.host, parsed_url.port) {|http|
					response = http.head(parsed_url.path)
				}
				readable = (response.code.to_i == 200)
				downloaded = false
			end

			if (readable)
				if downloaded
					puts tabs + "\t" + "<Downloaded> " + url
					@logging.puts tabs + "\t" + "<Downloaded> " + url unless @logging.nil?
				else
					puts tabs + "\t" + "<Public> " + url
					@logging.puts tabs + "\t" + "<Public> " + url unless @logging.nil?
				end
			else
				puts tabs + "\t" + "<Private> " + url
				@logging.puts tabs + "\t" + "<Private> " + url unless @logging.nil?
			end
		end

	elsif doc.elements['Error']
		err = doc.elements['Error']
		if !err.elements['Code'].nil?
			case err.elements['Code'].text
				when "NoSuchKey"
					puts tabs + "The specified key does not exist: " + bucket_name
					@logging.puts tabs + "The specified key does not exist: " + bucket_name unless @logging.nil?
				when "AccessDenied"
					puts tabs + "Bucket found but access denied: " + bucket_name
					@logging.puts tabs + "Bucket found but access denied: " + bucket_name unless @logging.nil?
				when "NoSuchBucket"
					puts tabs + "Bucket does not exist: " + bucket_name
					@logging.puts tabs + "Bucket does not exist: " + bucket_name unless @logging.nil?
				when "PermanentRedirect"
					if !err.elements['Endpoint'].nil?
						puts tabs + "Bucket " + bucket_name + " redirects to: " + err.elements['Endpoint'].text
						@logging.puts tabs + "Bucket " + bucket_name + " redirects to: " + err.elements['Endpoint'].text unless @logging.nil?

						data = get_page 'http://' + err.elements['Endpoint'].text, ''
						if data != ''
							doc = REXML::Document.new(data)
							parse_results doc, bucket_name, err.elements['Endpoint'].text, download, depth + 1
						end
					else
						puts tabs + "Redirect found but can't find where to: " + bucket_name
						@logging.puts tabs + "Redirect found but can't find where to: " + bucket_name unless @logging.nil?
					end
			end
		else
#			puts res.body
		end
	else
		puts tabs + ' No data returned'
		@logging.puts tabs + ' No data returned' unless @logging.nil?
	end
end

opts = GetoptLong.new(
	[ '--help', '-h', GetoptLong::NO_ARGUMENT ],
	[ '--region', '-r', GetoptLong::REQUIRED_ARGUMENT ],
	[ '--log-file', '-l', GetoptLong::REQUIRED_ARGUMENT ],
	[ '--download', '-d', GetoptLong::NO_ARGUMENT ],
	[ "-v" , GetoptLong::NO_ARGUMENT ]
)

# setup the defaults
download = false
verbose = false
region = "us"
@logging = nil

begin
	opts.each do |opt, arg|
		case opt
			when '--help'
				usage
			when '--download'
				download = true
			when "--log-file"
				begin
					@logging = File.open(arg, "w")
				rescue
					puts "Could not open the logging file\n"
					exit
				end
			when "--region"
				region = arg
		end
	end
rescue
	usage
end

if ARGV.length != 1
	puts "Missing wordlist (try --help)"
	exit 0
end

filename = ARGV.shift

case region
	when "ie"
		host = ('http://s3-eu-west-1.amazonaws.com')
	when "nc"
		host = ('http://s3-us-west-1.amazonaws.com')
	when "us"
		host = ('http://s3.amazonaws.com')
	when "si"
		host = ('http://s3-ap-southeast-1.amazonaws.com')
	when "to"
		host = ('http://s3-ap-northeast-1.amazonaws.com')
	else
		puts "Unknown region specified"
		puts
		usage
end

if !File.exists? filename
	puts "Wordlist file doesn't exist"
	puts
	usage
	exit
end

File.open(filename, 'r').each { |name|
	name.strip!
	if name == ""
		next
	end

	data = get_page host, name
	if data != ''
		doc = REXML::Document.new(data)
		parse_results doc, name, host, download, 0
	end
}

@logging.close unless @logging.nil?
