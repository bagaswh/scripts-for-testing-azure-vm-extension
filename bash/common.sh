set -e

# update
sudo apt update

# create swap
if free | awk '/^Swap:/ {exit !$2}'; then
    echo "swap exists, skipping swap creation..."
else
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo cat <<EOF >>/etc/fstab
/swapfile swap swap defaults 0 0
EOF
fi

sudo swapon --show
