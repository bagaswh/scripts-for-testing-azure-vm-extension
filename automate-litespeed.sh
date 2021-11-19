set -e

# setup default vhost directory
vhost_root=/var/www/lsws_vhosts/main
mkdir -p $vhost_root
chown azureuser:www-data $vhost_root

# lsws log directory
server_log=/var/log/lsws
server_access_log=$server_log/access.log
server_error_log=$server_log/error.log

# default vhost log directory
vhost_log=$vhost_root/log
mkdir -p $vhost_log
chown www-data:adm $vhost_log

vhost_access_log=$vhost_log/access.log
vhost_error_log=$vhost_log/error.log

export HTTPD_CONFIG_PATH=assets/httpd_config.conf

# do:
# - set user permission for LiteSpeed and ext apps
# - enable ddos protection
# - enable server error and access log
cat ./assets/httpd_config.conf >$HTTPD_CONFIG_PATH

ls -l $HTTPD_CONFIG_PATH

export VHOST_CONFIG_PATH=/usr/local/lsws/conf/vhosts/main/vhconf.conf
mkdir -p /usr/local/lsws/conf/vhosts/main/
chown lsadm:www-data /usr/local/lsws/conf/vhosts/main/
touch $VHOST_CONFIG_PATH
chmod 750 -R /usr/local/lsws/conf/vhosts/main/

mkdir -p /var/log/lsws
chown nobody:nogroup -R /var/log/lsws/
chmod 640 -R /var/log/lsws

# apply config change
service lsws restart

# reinstall OLS to refresh file ownership
apt install --reinstall -y openlitespeed

# vhost setup
mkdir -p /var/log/lsws/vhosts/main/
chown www-data:www-data -R /var/log/lsws/
chmod 640 -R /var/log/lsws/vhosts/main/
cat ./assets/httpd_config.conf >$VHOST_CONFIG_PATH
