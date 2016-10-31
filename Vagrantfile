BASE_DIRECTORY = File.expand_path(File.dirname(__FILE__))
SYNCED_FOLDER_TYPE = Vagrant::Util::Platform.windows? ? 'virtualbox' : 'nfs'

Vagrant.configure("2") do |config|

  config.vm.box = "debian/jessie64"
  config.vm.box_version = "8.5.2"

  config.vm.network :private_network, ip: "192.168.56.121"
  config.vm.synced_folder BASE_DIRECTORY, "/vagrant", type: SYNCED_FOLDER_TYPE

  config.vm.hostname = "demo.lizardsandpumpkins.com.loc"
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.name = "Lizards & Pumpkins Demo VM"
  end

  config.vm.provision "shell", path: "provisioning/init-vm.sh"
  config.vm.provision "shell", path: "provisioning/scripts/always.sh", run: "always"
end
