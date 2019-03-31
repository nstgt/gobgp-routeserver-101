Vagrant.configure(2) do |config|

  UUID = 'gobgp-101'

  # rs gobgp
  config.vm.define :rs do |rs|
    rs.vm.box = "bento/debian-9.6"
    rs.vm.network "private_network", virtualbox__intnet: "#{UUID}_ixp_subnet", auto_config: false
    rs.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 512
    end
    rs.vm.provision "shell", privileged: true, inline: <<-EOS
      grep 127.0.1.2 /etc/hosts || echo 127.0.1.2 rs >> /etc/hosts
      hostnamectl set-hostname rs
      echo "auto eth1"                   > /etc/network/interfaces.d/eth1
      echo "iface eth1 inet static"     >> /etc/network/interfaces.d/eth1
      echo " address 10.173.176.211"    >> /etc/network/interfaces.d/eth1
      echo " netmask 255.255.255.0"     >> /etc/network/interfaces.d/eth1
      echo "iface eth1 inet6 static"    >> /etc/network/interfaces.d/eth1
      echo " address 2001:db8:7:1::211" >> /etc/network/interfaces.d/eth1
      echo " netmask 64"                >> /etc/network/interfaces.d/eth1
      ifup eth1
      systemctl restart rsyslog
      apt-get update && apt-get install -y vim git
    EOS
    rs.vm.provision "shell", privileged: true, path: "prov/install_gobgp.sh"
  end

  # r1 - r3 junos/vqfx
  (1..3).each do |seq|
    re_name  = "r#{seq}".to_sym

    config.vm.define re_name do |r|
      r.vm.hostname = "r#{seq}"
      r.vm.box = 'juniper/vqfx10k-re'

      r.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      r.vm.synced_folder '.', '/vagrant', disabled: true

      # Management port (em1 / em2)
      r.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "#{UUID}_vqfx_internal_#{seq}"
      r.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "#{UUID}_reserved-bridge"

      # em3: IX subnet
      r.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "#{UUID}_ixp_subnet"
    end  
  end
end
