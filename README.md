# Recon My Way. 

##Recon my way -- tools and setting up Guide. 

### This repository contains the tools and scripts, I added in my recent blog post **Recon-My way**

https://medium.com/ehsahil/recon-my-way-82b7e5f62e21

I created this because there are many tools available these days and new users are confused about which tools to use and which are not much useful. 

Anyone can contribute to this repository If they think they have a useful tool. 


Standard machine I use. - Debian- 9.4 4 GB RAM on DigitalOcean (You can use according to your requirements.)

## Important things to Install before setting up tools (Debian Based systems)

### 1. Git Installation

```bash
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install git
```



### 2. Curl  installation. 

```bash
apt install curl
```bash


### 3. Go language installation. 

```bash
curl -O https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
sha256sum go1.10.2-linux-amd64.tar.gz
tar xvf go1.10.2.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
vi ~/.profile
```

## and add the following lines in `.profile`

```bash
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
source ~/.profile
```

### Cleaing Up-

```bash
root@recon-my-way:~ rm -rf go1.10.1.linux-amd64.tar.gz
root@recon-my-way:~ rm -rf work
```

### 4. Ruby Language installation. 

```bash
apt-get install ruby-full
```

### 5. Pip & pip3 install.

```bash
apt install python-pip
apt install python3-pip	#python 3
```

## Setting up tools for subdomain.rb & recon.rb. 

## subdomain.rb

### 1. Amass

```
cd /usr/local/go
go get -u github.com/caffix/amass
amass #test to run
```
### 2. Aquatone

```bash
root@recon-my-way:~# gem install aquatone
```

### 3. Knockpy
```bash
cd knock
sudo apt-get install python-dnspython
vi knockpy/config.json <- set your virustotal API_KEY
sudo python setup.py install

```
### 4. Subfinder

```
cd /usr/local/go
go get -u github.com/Ice3man543/subfinder
amass #test to run
```

### 5. Sublist3r (Optional)


## Setting up recon.rb

### 1. host 

```bash
# apt-get install dnsutils
```

### 2. Nmap

```bash
# apt-get install nmap
```
### 3. AWS CLI

```bash
pip install awscli

aws configure //Add your AWS keys
```


### 4. Dirsearch

Usage: 

```bash
python dirsearch -u https://url.com -e *(or any file extension)
```


### 5. GoBuster

```
cd /usr/local/go
go get -u github.com/Ice3man543/subfinder
amass #test to run
```



other useful tools will be locally saved when you clone this repository. 


