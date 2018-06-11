require 'socket'
require 'colorize'

begin
  file = File.open(ARGV[0], "r")
rescue
  puts "Usage: ruby resolve.rb filename (where filename contains a list of domains)"
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

  puts "#{subdomain}: #{ip}".colorize(color)
  system("nmap -F #{ip}") unless ip.eql?("unknown")
  puts
  puts "+-----------------------------------------------------------------------------------+"
  puts
end
