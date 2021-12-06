set -e

echo "=== wget -q $base_url/assets/litespeed-confs/httpd_config.conf -O httpd_config.conf ==="
wget -q $base_url/assets/litespeed-confs/httpd_config.conf -O httpd_config.conf
cat httpd_config.conf

echo "=== wget -q $base_url/assets/litespeed-confs/vhconf.conf -O vhconf.conf ==="
wget -q $base_url/assets/litespeed-confs/vhconf.conf -O vhconf.conf
echo 'downloaded vhconf.conf'
cat vhconf.conf

echo "=== wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash ==="
wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash
echo "=== apt-get install -y openlitespeed ==="
apt-get install -y openlitespeed

echo "=== apt-get install lsphp74-* lsphp80-* -y ==="
apt-get install lsphp74-* lsphp80-* -y

# web user
useradd -r -s /sbin/nologin webuser
usermod -a -G webuser www-data

# setup default vhost directory
vhost_dir=/var/www/lsws_vhosts
vhost_root=$vhost_dir/main
mkdir -p $vhost_root
chown azureuser:webuser -R $vhost_dir
chmod 750 -R $vhost_dir

# lsws log directory
server_log=/var/log/lsws
mkdir -p $server_log
chown www-data:adm -R $server_log
chmod 740 -R $server_log

export HTTPD_CONFIG_PATH=/usr/local/lsws/conf/httpd_config.conf

# do:
# - set user permission for LiteSpeed and ext apps
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

echo "=== service lsws stop ==="
service lsws stop
sudo rm -rf /tmp/lshttpd

# reinstall OLS to refresh file ownership
echo "=== apt-get -y install --reinstall openlitespeed ==="
apt-get -y install --reinstall openlitespeed

echo "=== service lsws start ==="
service lsws start

# for vhost root
mkdir -p $vhost_dir/html

mkdir $vhost_root/html
echo "=== wget -q $base_url/assets/litespeed-confs/index.html -O index.html ==="
wget -q $base_url/assets/litespeed-confs/index.html -O index.html
cp index.html $vhost_dir/html
chown azureuser:webuser -R $vhost_dir/html
find $vhost_dir -type f -exec chmod 660 {} \;
find $vhost_dir -type d -exec chmod 770 {} \;

echo "=== service lsws restart ==="
service lsws restart
