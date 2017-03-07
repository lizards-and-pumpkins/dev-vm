#!/usr/bin/env bash

[ "$UID" != 0 ] && {
        echo "This script has to be run as root" >&1
        exit 2
}

cd /vagrant

ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts

deb='deb http://packages.dotdeb.org jessie all'
debSrc='deb-src http://packages.dotdeb.org jessie all'
aptSources=/etc/apt/sources.list
grep -q -F "$deb" "$aptSources" || echo "$deb" >> "$aptSources"
grep -q -F "$debSrc" "$aptSources" || echo "$debSrc" >> "$aptSources"

gpg --keyserver keys.gnupg.net --recv-key 89DF5277
gpg -a --export 89DF5277 | apt-key add -

apt-key update
apt-get update
apt-get -y install git-core
apt-get -y install vim

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -y install mysql-server

apt-get -y install nginx
cp provisioning/sample/demo.lizardsandpumpkins.com.loc /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/demo.lizardsandpumpkins.com.loc /etc/nginx/sites-enabled/
/etc/init.d/nginx restart

grep -q -F 'demo.lizardsandpumpkins.com.loc' /etc/hosts || echo 127.0.0.1 demo.lizardsandpumpkins.com.loc >> /etc/hosts

apt-get -y install php-fpm php-mysql php-curl php7.0-intl php7.0-gd php7.0-mbstring php7.0-xml php7.0-xdebug \
    php7.0-imagick curl unzip

sed -i -e 's/^display_errors = Off$/display_errors = On/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/^display_errors = Off$/display_errors = On/' /etc/php/7.0/cli/php.ini

echo xdebug.remote_enable=On >> /etc/php/7.0/cli/conf.d/20-xdebug.ini
echo xdebug.remote_connect_back=On >> /etc/php/7.0/cli/conf.d/20-xdebug.ini

/etc/init.d/php7.0-fpm reload

curl -sL https://getcomposer.org/composer.phar -o /usr/local/bin/composer
chmod 0755 /usr/local/bin/composer

curl -sL https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -o /usr/local/bin/modman
chmod 0755 /usr/local/bin/modman

curl -sL https://files.magerun.net/n98-magerun.phar -o /usr/local/bin/n98-magerun
chmod 0755 /usr/local/bin/n98-magerun

cp provisioning/sample/motd /etc/motd
chmod 0644 /etc/motd

cp provisioning/sample/lizards-and-pumpkins-consumers /etc/init.d/
chmod 0755 /etc/init.d/lizards-and-pumpkins-consumers
update-rc.d lizards-and-pumpkins-consumers defaults

cp provisioning/sample/magento-export /etc/init.d/
chmod 0755 /etc/init.d/magento-export
update-rc.d magento-export defaults
