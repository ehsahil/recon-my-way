# Recon My Way. 

## Recon my way -- tools and setting up Guide. 

### This repository contains the tools and scripts, I added in my recent blog post "Recon-My way" and I personally use. 

Here is my blogpost if you have'nt read it yet. https://medium.com/ehsahil/recon-my-way-82b7e5f62e21

I created this repository for personal use to reduce the installation time on the new machine I work on. 

Machine Configuration - Debian- 9.4, 4 GB RAM on DigitalOcean (You can use any config but this is recommanded)

## Important things to Install before setting up tools (Debian Based OS)

### Git Installation

```bash
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install git
```



### Curl  installation. 

```bash
apt install curl
```


### Go language installation. 

```bash
curl -O https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
sha256sum go1.10.2-linux-amd64.tar.gz
tar xvf go1.10.2.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
vi ~/.profile
```

#### and add the following lines in `.profile`

```bash
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
source ~/.profile
```

### Cleaing Up

```bash
root@recon-my-way:~ rm -rf go1.10.1.linux-amd64.tar.gz
root@recon-my-way:~ rm -rf work
```

### Ruby Language installation. 

```bash
apt-get install ruby-full
```

### Pip & pip3 install.

```bash
apt install python-pip
apt install python3-pip	//for python 3
```

## Setting up tools for subdomain.rb & recon.rb. 

## subdomain.rb

### Amass

```
cd /usr/local/go
go get -u github.com/caffix/amass
amass #test to run
```
### Aquatone

```bash
root@recon-my-way:~# gem install aquatone
```

### Knockpy
```bash
cd knock
sudo apt-get install python-dnspython
vi knockpy/config.json <- set your virustotal API_KEY
sudo python setup.py install

```
### Subfinder

```
cd /usr/local/go
go get -u github.com/Ice3man543/subfinder
amass #test to run
```

### Sublist3r (Optional)


## Setting up recon.rb

### host 

```bash
# apt-get install dnsutils
```

### Nmap

```bash
# apt-get install nmap
```
### AWS CLI

```bash
pip install awscli

aws configure //Add your AWS keys
```


### Dirsearch

Usage: 

```bash
python dirsearch -u https://url.com -e *(or any file extension)
```


### GoBuster

```
cd /usr/local/go
go get -u github.com/Ice3man543/subfinder
amass #test to run
```



If you think you have a tool, which will reduce the operations time and useful, feel free to contact me via twitter. 

[![Twitter](https://img.shields.io/badge/twitter-@ehsahil-blue.svg)](https://twitter.com/ehsahil)

