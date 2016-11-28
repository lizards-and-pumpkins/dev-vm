#!/usr/bin/env bash

echo -e "\n\nThe Developer VM is ready.\n"
echo "If this is the first boot, please give it a few minutes to complete the initial import."
echo "How long? Run ~/sample-project/src/lizards-and-pumpkins/bin/reportQueueCount.php"

~/sample-project/src/lizards-and-pumpkins/bin/reportQueueCount.php

echo -e "Once both counts reach zero it is done."
echo -e "\nIf you haven't done so yet, please add '192.168.56.121 demo.lizardsandpumpkins.com.loc' to your local hosts file."
echo "After that you will be able to access Lizards & Pumpkins at http://demo.lizardsandpumpkins.com.loc/"
