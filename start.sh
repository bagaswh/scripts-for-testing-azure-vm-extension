set -e

echo 'checking stuffs...'
whoami
pwd
ls

apt update
apt install unzip curl -y

wget -q https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master/common.sh -O common.sh
wget -q https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master/automate-litespeed.sh -O automate-litespeed.sh
wget -q https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master/automate-nginx.sh -O automate-nginx.sh
wget -q https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master/automate-nodejs.sh -O automate-nodejs.sh

chmod +x ./*.sh

./common.sh
./automate-litespeed.sh
