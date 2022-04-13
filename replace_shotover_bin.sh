#!/bin/bash
set -e
sudo mv shotover-proxy/target/release/shotover-proxy /usr/bin/shotover-proxy
sudo rm -r shotover-proxy
sudo systemctl restart shotover
