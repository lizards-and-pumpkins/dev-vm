# Lizards & Pumpkins Demo VM

Please refer to [Demo VM section of Lizards & Pumpkins Wiki](https://github.com/lizards-and-pumpkins/catalog/wiki/Demo-VM) for installation and usage instructions.

## Starting & Stopping Services

The Lizards & Pumpkins sample project contains 3 background processes:

* Command Message Consumers
* Event Message Consumers
* Example Magento Export Process

When the VM boots the processes are started automatically.  
To start or stop the consumers, the following init script can be used:
 
`/etc/init.d/lizards-and-pumpkins-consumers {start|stop|status}`

To start or stop the Magento export service, use the init script

`/etc/init.d/magento-export {start|stop|status}`

## Finding your way inside the VM


| Information                    | Value                     |
|--------------------------------|---------------------------|
| L&P Environment Config         | /vagrant/provisioning/sample/env |
| L&P Utility Scripts            | /vagrant/sample-project/src/lizards-and-pumpkins/bin |
| Sample project base directory: | /vagrant/sample-project |
| Sample project storage root:   | /vagrant/sample-project/share |
| WWW document root:             | /vagrant/sample-project/pub |
| Demo-VM IP Address:            | 192.168.56.121 |
| Demo-VM Domain Name:           | demo.lizardsandpumpkins.com.loc |
| NGINX config:                  | /etc/nginx/sites-enabled/demo.lizardsandpumpkins.com.loc |
| Magento root directory:        | /vagrant/sample-project/src/magento |
| MySQL root password            | root |
| Local write mounts             | /tmp/magento/session-dir and cache-dir |

