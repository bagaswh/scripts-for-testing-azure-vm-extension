set -e

echo '=== apt-get install dialog apt-utils -y ==='
apt-get install dialog apt-utils -y

# create swap
if free | awk '/^Swap:/ {exit !$2}'; then
    echo "swap exists, skipping swap creation..."
else
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    cat <<EOF >>/etc/fstab
/swapfile swap swap defaults 0 0
EOF
fi

swapon --show

# TODO: increase ulimit
# ...

# certbot
echo '=== apt-get install snapd ==='
apt-get install snapd
echo '=== snap install core ==='
snap install core
echo '=== snap refresh core ==='
snap refresh core
echo '=== snap install --classic certbot ==='
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
