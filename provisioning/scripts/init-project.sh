#!/usr/bin/env bash

[ "$(whoami)" != 'vagrant' ] && {
    echo "This script has to be run as the vagrant user"
    exit 2
}

set -e

cd /vagrant

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

git clone https://github.com/lizards-and-pumpkins/sample-project.git
cd sample-project/
git checkout issue-1 # TODO: Remove once "issue-1" is merged into "master"
git submodule update --init --recursive
cd ..

mkdir sample-project/share
mkdir sample-project/share/log
mkdir sample-project/tmp

git clone --depth 1 https://github.com/OpenMage/magento-lts.git sample-project/src/magento

git clone --depth 1 https://github.com/riconeitzel/magento_sample_data_1.9.1.0_clean.git
mv magento_sample_data_1.9.1.0_clean/src/media sample-project/share/

cp provisioning/sample/my.cnf ~/.my.cnf

echo 'CREATE DATABASE IF NOT EXISTS `lizards-and-pumpkins-demo`' | mysql
mysql lizards-and-pumpkins-demo < magento_sample_data_1.9.1.0_clean/src/magento_sample_data_for_1.9.1.0.sql
echo "INSERT INTO core_config_data
   (path, value) VALUES
   ('web/unsecure/base_url', 'http://demo.lizardsandpumpkins.com.loc/'),
   ('web/secure/base_url', 'http://demo.lizardsandpumpkins.com.loc/');" | mysql lizards-and-pumpkins-demo
rm -fr magento_sample_data_1.9.1.0_clean

cp provisioning/sample/local.xml sample-project/share/

source sample-project/build/init.sh /vagrant/sample-project

php /vagrant/provisioning/triggerMagentoSetupScripts.php

rm -rf /vagrant/sample-project/src/magento/var/cache/

source /vagrant/provisioning/sample/env
echo "source /vagrant/provisioning/sample/env" >> ~/.bash_profile

/etc/init.d/magento-export start
/etc/init.d/lizards-and-pumpkins-consumers start

source /vagrant/sample-project/build/buildLizardsAndPumpkinsSnippets.sh /vagrant/sample-project

ln -s /vagrant/sample-project ~/sample-project
