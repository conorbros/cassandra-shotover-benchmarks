sudo yum update -y
sudo yum install git openssl-devel openssl perf -y
sudo yum groupinstall "Development Tools" -y
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
cargo install inferno
git clone https://github.com/shotover/shotover-proxy
