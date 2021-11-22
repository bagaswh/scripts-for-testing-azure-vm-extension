set -e

wget -q $base_url/assets/litespeed-confs/httpd_config.conf -O httpd_config.conf
echo 'downloade httpd_config.conf'
cat httpd_config.conf

wget -q $base_url/assets/litespeed-confs/vhconf.conf -O vhconf.conf
echo 'downloaded vhconf.conf'
cat vhconf.conf

wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | sudo bash
apt install -y openlitespeed

sudo apt install lsphp74-* -y
sudo apt install lsphp80-* -y

# setup default vhost directory
vhost_root=/var/www/lsws_vhosts/main
mkdir -p $vhost_root
chown azureuser:www-data -R $vhost_root
chmod 750 -R $vhost_root

# lsws log directory
# server_log=/var/log/lsws
# mkdir -p $server_log
# chown www-data:www-data -R $server_log
# chmod 640 -R $server_log

# default vhost log directory
# vhosts_log_dir=/var/log/lsws/vhosts
# vhost_log=$vhosts_log_dir/main
# mkdir -p $vhost_log
# chown www-data:www-data -R $vhosts_log_dir
# chmod 640 -R $vhosts_log_dir

export HTTPD_CONFIG_PATH=/usr/local/lsws/conf/httpd_config.conf

# do:
# - set user permission for LiteSpeed and ext apps
# - enable ddos protection
# - enable server error and access log
cat ./httpd_config.conf >$HTTPD_CONFIG_PATH

vhost_config_dir=/usr/local/lsws/conf/vhosts/main/
mkdir -p $vhost_config_dir
chown lsadm:www-data $vhost_config_dir
chmod 750 -R $vhost_config_dir

export VHOST_CONFIG_PATH=$vhost_config_dir/vhconf.conf
touch $VHOST_CONFIG_PATH

# vhost setup
# do:
# - always rewrite to https
# - block sensitive files
cat ./vhconf.conf >$VHOST_CONFIG_PATH

service lsws stop

# reinstall OLS to refresh file ownership
apt-get -y install --reinstall openlitespeed

sudo systemctl restart lsws
