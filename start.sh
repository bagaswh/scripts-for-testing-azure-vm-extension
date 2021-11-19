set -e

echo 'checking stuffs...'
whoami
pwd
ls

apt update
apt install unzip curl -y

if [ -z "$scripts_url" ]; then
    scripts_url=https://github.com/bagaswh/scripts-for-testing-azure-vm-extension/raw/master/zip/scripts.zip
fi

rm scripts.zip || true
wget $scripts_url -O scripts.zip

rm -rf actual_scripts || true
mkdir actual_scripts
unzip scripts.zip -d actual_scripts
chmod +x -R actual_scripts
cd actual_scripts

./common.sh

./automate-litespeed.sh
