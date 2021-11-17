set -e

wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | sudo bash
sudo apt-get install openlitespeed

# set user permission for LiteSpeed and ext apps
# enable ddos protection

# setup vhost directory
vhosts=/var/www/lsws_vhosts
sudo mkdir -p $vhosts
sudo chown azureuser:www-data $vhosts
