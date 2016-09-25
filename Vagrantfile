BASE_DIRECTORY = File.expand_path(File.dirname(__FILE__))
SYNCED_FOLDER_TYPE = Vagrant::Util::Platform.windows? ? 'virtualbox' : 'nfs'

Vagrant.configure("2") do |config|

  config.vm.box = "debian/jessie64"
  config.vm.box_version = "8.5.2"

  config.vm.network :private_network, ip: "33.33.33.77"
  config.vm.synced_folder BASE_DIRECTORY, "/vagrant", type: SYNCED_FOLDER_TYPE

  config.vm.hostname = 'demo.lizardsandpumpkins.com.loc'
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.name = "Lizards & Pumpkins Demo VM"
  end

  config.vm.provision "shell", path: "provisioning/init-vm.sh"
end
