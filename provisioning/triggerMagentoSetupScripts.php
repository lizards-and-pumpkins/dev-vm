<?php

ini_set('memory_limit', '1024M');
set_time_limit(0);
umask(0);

require_once __DIR__ . '/../sample-project/src/magento/app/Mage.php';

Mage::app('admin', 'store', ['global_ban_use_cache' => true]);

Mage_Core_Model_Resource_Setup::applyAllUpdates();
Mage_Core_Model_Resource_Setup::applyAllDataUpdates();

Mage::getConfig()->getOptions()->setData('global_ban_use_cache', false);
Mage::app()->baseInit([]);
Mage::getConfig()->loadModules()->loadDb()->saveCache();
