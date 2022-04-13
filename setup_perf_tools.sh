#!/bin/bash
set -e

# install deps

sudo yum update -y
sudo yum install git openssl-devel openssl perf -y
sudo yum groupinstall "Development Tools" -y

# install rust and rust deps

curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
cargo install inferno

# install shotover
git clone https://github.com/conorbros/shotover-proxy
cd shotover-proxy
git checkout benches


# build shotover and replace existing binary

cargo build --release
cd ..
