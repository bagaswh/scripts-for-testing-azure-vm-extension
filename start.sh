set -e

echo 'checking stuffs...'
whoami
pwd
ls

apt update
apt install zip unzip curl -y

if [ -z "$base_url" ]; then
    base_url="https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master"
fi

export base_url=$base_url

wget -q $base_url/common.sh -O common.sh
wget -q $base_url/automate-litespeed.sh -O automate-litespeed.sh
wget -q $base_url/automate-nginx.sh -O automate-nginx.sh
wget -q $base_url/automate-nodejs.sh -O automate-nodejs.sh

chmod +x ./*.sh

./common.sh
./automate-litespeed.sh
./automate-nodejs.sh

apt upgrade -y
