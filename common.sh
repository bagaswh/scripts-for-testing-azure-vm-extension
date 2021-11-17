set -e

# update
sudo apt update

# create swap
sudo swapoff -a
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cat <<EOF >>/etc/fstab
/swapfile swap swap defaults 0 0
EOF
sudo swapon /swapfile
sudo swapon --show
