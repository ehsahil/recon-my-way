#Tools based on a resolver.rb by @melvinsh
#Repository: https://github.com/melvinsh/subresolve
#Modified by @ehsahil for Personal Use.
require 'socket'
require 'colorize'
begin
   domain = ARGV[0]
rescue
   puts "Usage: ruby subdomain.rb domain"
   exit
end
  puts "+--------------------------------Subdomains By Subfinder-------------------------------------+"
  #Get it from https://github.com/Ice3man543/subfinder
  system("Docker run -it subfinder -d #{domain}")
  puts "Subfinder Ended..."
  puts
  #Get it from https://github.com/christophetd/censys-subdomain-finder
  puts "+--------------------------------Subdomains BY Censys-------------------------------------+"
  system("python censys-subdomain-finder/censys_subdomain_finder.py #{domain}")
  puts "Censys Ended..."
  puts
  puts "Knockpy Started....."
  #Get it from https://github.com/guelfoweb/knock
  puts "+-------------------------------Subdomains by Knockpy-------------------------------------+"
  system("knockpy #{domain}")
  puts "Knockpy Ended....."
  puts
  puts "Sublist3r Started....."
  #Get it from https://github.com/aboul3la/Sublist3r
  puts "+-------------------------------Subdomains BY Sublister-----------------------------------+"
  system("python Sublist3r/Sublist3r.py -d #{domain}")
  puts "SUBLISTER ENDED..."
  puts
  puts "Aquatone-discover Started....."
  #Get it from https://github.com/michenriksen/aquatone
  puts "+--------------------------------Subdomains By Aquatone-discover------------------------------------+"
  system("aquatone-discover --domain #{domain}")
  puts "Aquatone-discover Ended..."
  puts
  puts "+--------------------------------Subdomains By Aquatone-takeover------------------------------------+"
  #Quick auto test for any subdomain takeover. 
  system("aquatone-takeover --domain #{domain}")
  puts "Aquatone-takeover Ended..."



