# Recon My Way. 

Recon my way -- tools and setting up Guide. 

This repository contains the tools and scripts, I added in my recent blog post **Recon-My way**

https://medium.com/ehsahil/recon-my-way-82b7e5f62e21

I created this because there are many tools available these days and new users are confused about which tools to use and which are not much useful. 

Anyone can contribute to this repository If they think they have a useful tool. 

I have also added my two simple scripts. 

subdomain.rb & recon.rb 

Standard machine to use. - Debian- 9.4 4 GB RAM on DigitalOcean (You can use according to your requirements.)

Installation instructions. (Debian Based systems)

1. Git Installation
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install git

2. Curl  installation. 

apt install curl

3. Go language installation. 

 curl -O https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
 sha256sum go1.10.2-linux-amd64.tar.gz
tar xvf go1.10.2.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
vi ~/.profile

and add

export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
source ~/.profile

Cleaing Up-

root@recon-my-way:~ rm -rf go1.10.1.linux-amd64.tar.gz
root@recon-my-way:~ rm -rf work


4. Ruby Language installation. 

apt-get install ruby-full


5. Pip & pip3 install.

apt install python-pip
apt install python3-pip	#python 3

Setting up tools for subdomain.rb & recon.rb. 

for subdomain.rb

1. Amass

cd /usr/local/go
go get -u github.com/caffix/amass
amass

2. Aquatone

root@recon-my-way:~# gem install aquatone

3. Knockpy

4. Subfinder

5. Sublist3r (Optional)

for recon.rb

1. host 
2. nmap
3. AWS CLI
4. Dirsearch/Gobuster. 



Tools installation. 

1. JSParser

2. LinkFinder

3. VHost Scan

4. AltDNS

5. Amass

6. Aquatone

7. Bucket Finder.

8. Censys Enumeration. 

9. Censys subdomain finder. 

10. Dirsearch

11. Domain Profiler

12. Domains from CSP

13. Knock

14. Lazy Recon. 

15. LazyS3

16. Lazy Shot

17. Mass Scan

18. S3 Bucket Finder

19. Sub Resolve. 

20. WebScreenshot

21. recon.rb 

22. subdomain.rb 

23. waybackurl.py 

