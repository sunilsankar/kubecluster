# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV['VAGRANT_NO_PARALLEL'] = 'yes'
# Check required plugins
REQUIRED_PLUGINS_LIBVIRT = %w(vagrant-libvirt)
exit unless REQUIRED_PLUGINS_LIBVIRT.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end
Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = false
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = false
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/pre.yaml"
  end    
  

    config.vm.define "kubemaster", primary: true do |awx|
      awx.vm.box = "centos/7"
      awx.vm.hostname = 'kubemaster'
      awx.vm.box_check_update = true
      awx.vm.network :private_network, ip: "192.168.30.200"
      awx.vm.provider :libvirt do |domain|
        domain.memory = 4096
      domain.cpus = 2
      domain.nested = true
    #  domain.storage :file, :size => '100G', :type => 'raw'
    end
    awx.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/master.yaml"
    end    
    

      end
      config.vm.define "client1", primary: true do |client1|
        client1.vm.box = "centos/7"
      client1.vm.hostname = 'kubeclient1'
      client1.vm.box_check_update = true
    #
       client1.vm.network :private_network, ip: "192.168.30.201"
          client1.vm.provider :libvirt do |domain|
          domain.memory = 2048
        domain.cpus = 2
        domain.nested = true
   #  #   domain.storage :file, :size => '100G', :type => 'raw'
      end
      client1.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/node.yaml"
      end    
      
  
        end
        config.vm.define "client2", primary: true do |client1|
          client1.vm.box = "centos/7"
        client1.vm.hostname = 'kubeclient2'
        client1.vm.box_check_update = true
      #
         client1.vm.network :private_network, ip: "192.168.30.202"
            client1.vm.provider :libvirt do |domain|
            domain.memory = 2048
          domain.cpus = 2
          domain.nested = true
     #  #   domain.storage :file, :size => '100G', :type => 'raw'
        end
        client1.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "ansible/node.yaml"
        end    
           
          end
    end