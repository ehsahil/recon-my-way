# Recon My Way. 

###  Tools and scripts setting up guide for personal use. 

This repository contains the tools and scripts, I added in my recent blog post "Recon-My way" and I personally use. 

Here is my blog post https://medium.com/ehsahil/recon-my-way-82b7e5f62e21

Machine Configuration I use - Debian- 9.4, 4 GB RAM on DigitalOcean (You can use any config but this is recommended)

## Important things to Install before setting up tools (Debian Based OS)

### Git Installation

```bash
root@recon-my-way:~# sudo apt-get upgrade
root@recon-my-way:~# sudo apt-get update
root@recon-my-way:~# sudo apt-get install git
```

### Curl  installation. 

```bash
root@recon-my-way:~# apt install curl
```

### Go language installation. 

```bash
root@recon-my-way:~# curl -O https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
root@recon-my-way:~# sha256sum go1.10.2-linux-amd64.tar.gz
root@recon-my-way:~# tar xvf go1.10.2.linux-amd64.tar.gz
root@recon-my-way:~# sudo chown -R root:root ./go
root@recon-my-way:~# sudo mv go /usr/local
root@recon-my-way:~# vi ~/.profile
```

#### and add the following lines in `.profile`

```bash
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
source ~/.profile
```

#### Cleaing Up

```bash
root@recon-my-way:~# rm -rf go1.10.1.linux-amd64.tar.gz
root@recon-my-way:~# rm -rf work
```

### Ruby Language installation. 

```bash
root@recon-my-way:~# apt-get install ruby-full
```

### Pip & pip3 install.

```bash
root@recon-my-way:~# apt install python-pip
root@recon-my-way:~# apt install python3-pip	//for python 3
```

## Setting up tools for subdomain.rb & recon.rb. 

## subdomain.rb

### colorize gem install

```bash
root@recon-my-way:~# gem install colorize
```


### Amass

```
root@recon-my-way:~# go get -u github.com/OWASP/Amass/...
```

### Aquatone

```bash
root@recon-my-way:~# gem install aquatone
```

### Knockpy
```bash
root@recon-my-way:~# cd knock
root@recon-my-way:~# sudo apt-get install python-dnspython
root@recon-my-way:~# vi knockpy/config.json <- set your virustotal API_KEY
root@recon-my-way:~# sudo python setup.py install

```
### Subfinder

```
root@recon-my-way:~# go get github.com/subfinder/subfinder
root@recon-my-way:~# subfinder //test run
```

### Subdomains by censys

```bash
root@recon-my-way:~# pip install censys
root@recon-my-way:~# export CENSYS_API_ID=Your_Censys_APP_ID
root@recon-my-way:~# export CENSYS_API_SECRET=Your_Censys_APP_ID
```

### Sublist3r (No longer using-Optional)

```bash
root@recon-my-way:~# git clone https://github.com/aboul3la/Sublist3r.git
root@recon-my-way:~# cd sublist3r
root@recon-my-way:~# sudo apt-get install python-requests
root@recon-my-way:~# sudo pip install -r requirements.txt

```

## recon.rb


### Host and other dns utils.  

```bash
root@recon-my-way:~# apt-get install dnsutils
```

### Nmap

```bash
root@recon-my-way:~# apt-get install nmap
```

### AWS CLI

```bash
root@recon-my-way:~# pip install awscli

root@recon-my-way:~# aws configure //Add your AWS keys
```


### Dirsearch

Usage: 

```bash
root@recon-my-way:~# python dirsearch -u https://url.com -e *(or any file extension)
```


### GoBuster

```
root@recon-my-way:~# cd /usr/local/go
root@recon-my-way:~# go get -u github.com/OJ/gobuster
root@recon-my-way:~# gobuster //test run
```

Note: All credits goes to the original developers of the tools listed in this repository. I do not own any of the tool listed in this repository. 


### Contributors 
[![Twitter](https://img.shields.io/badge/twitter-@ehsahil-blue.svg)](https://twitter.com/ehsahil)

[![Twitter](https://img.shields.io/badge/twitter-@MukeshDhama-blue.svg)](https://twitter.com/MukeshDhama)


