#!/bin/bash

###
### INSTALL CASSANDRA
###
sudo yum install java-1.8.0-openjdk -y

cat <<EOF | sudo tee -a /etc/yum.repos.d/cassandra311x.repo
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS
EOF

sudo yum update -y

sudo yum install cassandra -y
sudo systemctl daemon-reload
sudo service cassandra stop

# clear out data
sudo rm -rf /var/lib/cassandra/data/system/*

###
###
###

###
### INSTALL SHOTOVER
###

wget https://github.com/shotover/shotover-proxy/releases/download/v0.1.2/shotover-proxy-linux_amd64-0.1.2.tar.gz
tar -xf shotover-proxy-linux_amd64-0.1.2.tar.gz

sudo mv shotover/shotover-proxy /usr/bin/shotover-proxy

wget https://raw.githubusercontent.com/shotover/shotover-proxy/main/shotover-proxy/config/config.yaml

sudo mkdir -p /etc/shotover/config
sudo mv config.yaml /etc/shotover/config/

wget https://raw.githubusercontent.com/conorbros/cassandra-shotover-benchmarks/master/shotover.service

sudo mv shotover.service /etc/systemd/system/shotover.service

sudo chmod 640 /etc/systemd/system/shotover.service

sudo systemctl enable shotover
