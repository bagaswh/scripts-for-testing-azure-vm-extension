#!/bin/bash

set -e

# update, upgrade
sudo apt update
sudo apt upgrade -y

# create swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cat <<EOF >>/etc/fstab
/swapfile swap swap defaults 0 0
EOF
sudo swapon --show
