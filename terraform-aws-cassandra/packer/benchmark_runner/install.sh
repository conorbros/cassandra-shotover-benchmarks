#!/bin/bash

set -e

sudo yum update -y
sudo yum install git openssl-devel openssl -y
sudo yum groupinstall "Development Tools" -y

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

sudo yum install cassandra -y

clear out data
sudo rm -rf /var/lib/cassandra/data/system/*


###
### INSTALL RUST
###
su -u ec2-user
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
