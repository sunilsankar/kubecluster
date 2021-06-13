# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder "./", "/vagrant"
   config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/pre.yaml"
  end

  # Kubernetes Master Server
  config.vm.define "kubemaster" do |node|
  
    node.vm.box               = "generic/ubuntu2004"
    node.vm.box_check_update  = false
    node.vm.hostname          = "kubemaster.example.com"

    node.vm.network "private_network", ip: "172.16.16.100"
  
    node.vm.provider :virtualbox do |v|
      v.name    = "kubemaster"
      v.memory  = 4096
      v.cpus    =  2
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = 4096
      v.nested  = true
      v.cpus    = 2
    end
     node.vm.provider :parallels do |v|
      v.memory  = 4096
      v.cpus    = 2
     end

     
    node.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/master.yaml"
    end
  
  end


  # Kubernetes Worker Nodes
  NodeCount = 3

  (1..NodeCount).each do |i|

    config.vm.define "client#{i}" do |node|

      node.vm.box               = "generic/ubuntu2004"
      node.vm.box_check_update  = false
      node.vm.hostname          = "client#{i}.example.com"

      node.vm.network "private_network", ip: "172.16.16.10#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "client#{i}"
        v.memory  = 2048
        v.cpus    = 2
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 2048
        v.nested  = true
        v.cpus    = 1
      end

       node.vm.provider :parallels do |v|
      v.memory  = 4096
      v.cpus    = 2
       end

      node.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "ansible/node.yaml"
        end 

    end

  end

end