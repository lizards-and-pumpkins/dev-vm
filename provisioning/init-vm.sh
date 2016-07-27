#!/bin/bash

cd /vagrant

ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts

deb='deb http://packages.dotdeb.org jessie all'
debSrc='deb-src http://packages.dotdeb.org jessie all'
aptSources=/etc/apt/sources.list
grep -q -F "$deb" "$aptSources" || sudo echo "$deb" >> "$aptSources"
grep -q -F "$debSrc" "$aptSources" || sudo echo "$debSrc" >> "$aptSources"

gpg --keyserver keys.gnupg.net --recv-key 89DF5277
gpg -a --export 89DF5277 | sudo apt-key add -

sudo apt-get update
sudo apt-get -y install git-core

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

sudo apt-get -y install nginx
sudo cp provisioning/sample/demo.lizardsandpumpkins.com.loc /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/demo.lizardsandpumpkins.com.loc /etc/nginx/sites-enabled/
sudo /etc/init.d/nginx restart

sudo apt-get -y install php-fpm
sudo apt-get -y install php-mysql
sudo apt-get -y install php-curl
sudo apt-get -y install php7.0-intl
sudo apt-get -y install php7.0-mbstring
sudo apt-get -y install php7.0-dev

sudo apt-get install unzip

sudo apt-get -y install imagemagick
sudo apt-get -y install libmagickwand-dev
git clone git@github.com:mkoppanen/imagick.git
cd imagick/
phpize
./configure
make
sudo make install

grep -q -F 'extension=imagick.so' /etc/php/7.0/cli/php.ini || echo extension=imagick.so >> /etc/php/7.0/cli/php.ini
grep -q -F 'extension=imagick.so' /etc/php/7.0/fpm/php.ini || echo extension=imagick.so >> /etc/php/7.0/fpm/php.ini

cd ..
rm -fr imagick/

git clone git@github.com:lizards-and-pumpkins/sample-project.git
cd sample-project/
git fetch; git checkout issue-1 # TODO: Remove once "issue-1" is merged into "master"
git submodule update --init --recursive
cd ..

mkdir sample-project/share

git clone git@github.com:OpenMage/magento-mirror.git
git apply --directory=magento-mirror/ provisioning/magento-php7.patch
mv magento-mirror sample-project/src/magento

git clone git@github.com:riconeitzel/magento_sample_data_1.9.1.0_clean.git
mv magento_sample_data_1.9.1.0_clean/src/media sample-project/share/
echo 'CREATE DATABASE IF NOT EXISTS `lizards-and-pumpkins-demo`' | mysql -u root -proot
mysql -u root -proot lizards-and-pumpkins-demo < magento_sample_data_1.9.1.0_clean/src/magento_sample_data_for_1.9.1.0.sql
rm -fr magento_sample_data_1.9.1.0_clean

cp provisioning/sample/local.xml sample-project/share/

bash < <(wget -q --no-check-certificate -O - https://raw.github.com/colinmollenhour/modman/master/modman-installer)
sudo mv ~/bin/modman /usr/local/bin/modman

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

source sample-project/build/init.sh /vagrant/sample-project

# TODO: Source env variables
# TODO: Start daemons (including Magento) if not running

source sample-project/build/buildLizardsAndPumpkinsSnippets.sh /vagrant/sample-project
