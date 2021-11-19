set -e

echo 'checking stuffs...'
whoami
pwd
ls

apt update
apt install unzip curl -y

./common.sh

./automate-litespeed.sh
