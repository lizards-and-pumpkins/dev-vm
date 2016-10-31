#!/bin/bash

set -e

/vagrant/provisioning/scripts/init-system.sh
chmod 0777 /vagrant
sudo -u vagrant /vagrant/provisioning/scripts/init-project.sh
chmod 0755 /vagrant
