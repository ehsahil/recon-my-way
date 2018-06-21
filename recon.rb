
#Tool based on a resolver.rb by @melvinsh
#Original Repository: https://github.com/melvinsh/subresolve
#Modified by @ehsahil for Personal Use.
#Tools used - Host, Nmap, AWS CLI, Dirsearch, Gobuster
require 'socket'
require 'colorize'

begin
  file = File.open(ARGV[0], "r")
rescue
  puts "Usage: ruby resolve.rb wordlist"
  exit
end

file.each_line do |subdomain|
  begin
    color = :green
    ip = IPSocket::getaddress(subdomain.strip)
  rescue
    color = :red
    ip = "unknown"
  end
  puts
  puts "Working On --> #{subdomain}"
  puts "Resolving Subdomain using Host."
  puts "+------------------------------------------------------------------------------------+"
  puts "#{subdomain}: #{ip}".colorize(color)
  system("Host #{subdomain}") unless ip.eql?("unknown")
  puts "Process Finished."
  puts
  puts "Nmap Process Started."
  puts
  # Get it From https://nmap.org
  puts "+------------------------------------------------------------------------------------+"
  puts "#{subdomain}: #{ip}".colorize(color)
  system("nmap -F #{ip}") unless ip.eql?("unknown")
  puts "Nmap Process finished."
  puts
  puts "AWS CLI Process Started."
  puts
  # Get it from https://aws.amazon.com/cli/
  puts "+-------------------------------------------------------------------------------------+"
  puts "#{subdomain}".colorize(color)
  system("aws s3 ls s3://#{subdomain}")
  puts "AWS CLI Process finished"
  puts 
  puts "Dirsearch Started."
  # Get it from https://github.com/maurosoria/dirsearch
  puts "+-------------------------------------------------------------------------------------+"
  puts "#{subdomain}".colorize(color)
  system("python3 dirsearch/dirsearch.py  -e * -u #{subdomain}")
  puts "Dirsearch Process Finished."
  puts "GoBuster Started."
  # Get it from https://github.com/OJ/gobuster
  # Comment out of delete the Dirsearch if you want to use Gobuster
  puts "+-------------------------------------------------------------------------------------+"
  puts "#{subdomain}".colorize(color)
  system("gobuster -w Wordlists/personal.txt -u #{subdomain}")
  puts "GoBuster Process Finished."
  puts
  puts
end
