set -e

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