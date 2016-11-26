#!/usr/bin/env bash

mkdir -p /tmp/magento/session-dir
chmod 0777 /tmp/magento/session-dir
mount -obind /tmp/magento/session-dir /vagrant/sample-project/src/magento/var/session


source /vagrant/provisioning/sample/env
/etc/init.d/magento-export start
/etc/init.d/lizards-and-pumpkins-consumers start

echo -e "\n\nThe Developer VM is ready."
echo "If this is the first boot, please give it a few minutes to complete the initial import."
echo "If you haven't done so yet, please add '192.168.56.121 demo.lizardsandpumpkins.com.loc' to your local hosts file."
echo "After that you will be able to access Lizards & Pumpkins at http://demo.lizardsandpumpkins.com.loc/"
