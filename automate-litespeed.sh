set -e

# setup default vhost directory
vhost_root=/var/www/lsws_vhosts/main
sudo mkdir -p $vhost_root
sudo chown wsl:www-data $vhost_root

# lsws log directory
server_log=/var/log/lsws
server_access_log=$server_log/access.log
server_error_log=$server_log/error.log

# default vhost log directory
vhost_log=$vhost_root/log
sudo mkdir -p $vhost_log
sudo chown www-data:adm $vhost_log

vhost_access_log=$vhost_log/access.log
vhost_error_log=$vhost_log/error.log

export HTTPD_CONFIG_PATH=assets/httpd_config.conf

sudo mkdir -p /var/log/lsws
sudo chown nobody:nogroup -R /var/log/lsws/
sudo chmod 740 -R /var/log/lsws

# do:
# - set user permission for LiteSpeed and ext apps
# - enable ddos protection
# - enable server error and access log
cat ./assets/httpd_config.conf >$HTTPD_CONFIG_PATH

# apply config change
sudo service lsws restart

# reinstall OLS to refresh file ownership
sudo apt install --reinstall -y openlitespeed

ls -l $HTTPD_CONFIG_PATH

export VHOST_CONFIG_PATH=/usr/local/lsws/conf/vhosts/main/vhconf.conf

# do:
# - enable vhost error and access log
# - block sensitive files using context
# sudo -E \
#     VHOST_ACCESS_LOG_PATH=$vhost_access_log \
#     VHOST_ERROR_LOG_PATH=$vhost_error_log \
#     DOC_ROOT=$VHOST_ROOT/html/ \
#     /home/wsl/.nvm/versions/node/v16.13.0/bin/node litespeed/litespeed-vhost-config.js

# sudo chown wsl:www-data $VHOST_CONFIG_PATH
# sudo chmod 750 $VHOST_CONFIG_PATH
