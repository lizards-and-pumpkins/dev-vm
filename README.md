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
| Sample project base directory: | /vagrant/sample-project (or ~/sample-project) |
| Sample project storage root:   | /vagrant/sample-project/share |
| WWW document root:             | /vagrant/sample-project/pub |
| Lizards & Pumpkins Log File    | /vagrant/sample-project/share/log/system.log |
| Demo-VM IP Address:            | 192.168.56.121 |
| Demo-VM Domain Name:           | demo.lizardsandpumpkins.com.loc |
| NGINX config:                  | /etc/nginx/sites-enabled/demo.lizardsandpumpkins.com.loc |
| Magento root directory:        | /vagrant/sample-project/src/magento |
| MySQL root password            | root |
| Magento admin user             | admin / password123 |
| Local write mounts             | /tmp/magento/session-dir and cache-dir |

## Helpful commands

List URL paths of pages available in Lizards & Pumpkins:

`/vagrant/sample-project/vendor/bin/lp report:url-keys {-t all|listing|product}`

Show the configured Lizards & Pumpkins environment:

`env | grep LP`

Clear the filesystem queues and data pool:

`rm -r /vagrant/sample-project/file-storage/*`

Run a full export from Magento:

`/vagrant/sample-project/build/buildLizardsAndPumpkinsSnippets.sh /vagrant/sample-project`

(Note: the above command will finish quickly because the actual process is running in the background.)

See the number of messages in the command and event queue:

`/vagrant/sample-project/vendor/bin/lp report:queue-count`
(I like to run `watch vendor/bin/lp report:queue-count`)

To start or stop worker processes interactively use the command  
`/vagrant/sample-project/vendor/lizards-and-pumpkins/catalog/bin/interactive-consumer-ui.sh`

To start or stop worker processes in a script, for example during provisioning, use  
`/vagrant/sample-project/vendor/lizards-and-pumpkins/catalog/bin/manage-consumer.sh (event|command) (start|stop) [count]`  
`/vagrant/sample-project/vendor/lizards-and-pumpkins/catalog/bin/manage-consumer.sh (event|command) stop-all`


### Additional notes:

#### Changing the environment configuration

The environment is currently specified in two places:

1. The script /vagrant/provisioning/sample/env
2. The nginx config /etc/nginx/sites-enabled/demo.lizardsandpumpkins.com.loc

When changing the configuration be sure to change it in both places.
We are aware this is not ideal as there should only be a single source of such information. PRs welcome.

#### Why do I still see catalog pages after emptying the data pool?

NGINX is configured to pass page requests that can't be processed by Lizards & Pumpkins through to Magento.

#### Getting more detailed information on what is being processed

Set and export the environment variable `LP_DEBUG_LOG` to 1 and restart the event and command consumers. 

This will log each processed event and command to the file `/vagrant/sample-project/share/log/system.log`.
With this data the script `sample-project/vendor/lizards-and-pumpkins/catalog/bin/lp report:event-processing-time-average <logfile>` can be used to extract processing time averages.
