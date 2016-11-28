#!/usr/bin/env bash

mkdir -p /tmp/magento/session-dir
chmod 0777 /tmp/magento/session-dir
mount -obind /tmp/magento/session-dir /vagrant/sample-project/src/magento/var/session


source /vagrant/provisioning/sample/env
/etc/init.d/magento-export start
/etc/init.d/lizards-and-pumpkins-consumers start

source "$(dirname $0)/welcome.sh"
