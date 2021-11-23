#!/bin/bash

set -e

id=72d34dab-01ef-448f-b92c-b3231a98c916
echo "id: $id"

echo 'checking stuffs...'
whoami
pwd
ls

echo '=== apt-get update ==='
apt-get update
echo '=== apt-get upgrade ==='
apt-get upgrade -y

echo '=== apt-get install zip unzip curl wget -y ==='
apt-get install zip unzip curl wget -y

if [ -z "$base_url" ]; then
    base_url="https://raw.githubusercontent.com/bagaswh/scripts-for-testing-azure-vm-extension/master"
fi

export base_url=$base_url

echo 'downloading scripts...'
wget -q $base_url/common.sh -O common.sh
echo 'downloaded common'
wget -q $base_url/automate-litespeed.sh -O automate-litespeed.sh
echo 'downloaded automate-litespeed'
wget -q $base_url/automate-nginx.sh -O automate-nginx.sh
echo 'downloaded automate-nginx'
wget -q $base_url/automate-nodejs.sh -O automate-nodejs.sh
echo 'downloaded automate-nodejs'
wget -q $base_url/automate-azpipelines-agent.sh -O automate-azpipelines-agent.sh
echo 'downloaded automate-azpipelines-agent'

chmod +x ./*.sh

./common.sh
./automate-litespeed.sh

cp ./automate-nodejs.sh /home/azureuser;
chown azureuser:azureuser /home/azureuser/automate-nodejs.sh
chmod u+x /home/azureuser/automate-nodejs.sh
sudo -H -u azureuser bash -c 'cd ~; ./automate-nodejs.sh'

./automate-azpipelines-agent.sh
