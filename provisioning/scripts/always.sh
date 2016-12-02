#!/usr/bin/env bash

mkdir -p /tmp/magento/session-dir
mkdir -p /vagrant/sample-project/src/magento/var/session
chmod 0777 /tmp/magento/session-dir /vagrant/sample-project/src/magento/var/session
mount | grep -q 'magento/var/sessions' || \
    mount -obind /tmp/magento/session-dir /vagrant/sample-project/src/magento/var/session


source /vagrant/provisioning/sample/env
/etc/init.d/magento-export start
/etc/init.d/lizards-and-pumpkins-consumers start

source /vagrant/provisioning/scripts/welcome.sh
