Vagrant.configure(2) do |config|
  # rs gobgp
  config.vm.define :rs do |rs|
    rs.vm.box = "bento/debian-9.6"
    rs.vm.network "private_network", ip: "10.173.176.211", virtualbox__intnet: "gobgp-101_ix"
    rs.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 512
    end
    rs.vm.provision "shell", privileged: true, inline: <<-EOS
      grep 127.0.1.2 /etc/hosts || echo 127.0.1.2 rs >> /etc/hosts
      hostnamectl set-hostname rs
      systemctl restart rsyslog
    EOS
    rs.vm.provision "shell", privileged: true, path: "prov/install_gobgp.sh"
  end

  # g1 gobgp/quagga
  config.vm.define :g1 do |g1|
    g1.vm.box = "bento/debian-9.6"
    g1.vm.network "private_network", ip: "10.173.176.101", virtualbox__intnet: "gobgp-101_ix"
    g1.vm.network "private_network", ip: "10.1.1.101",    virtualbox__intnet: "gobgp-101_1-to-3"
    g1.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 512
    end
    g1.vm.provision "shell", privileged: true, inline: <<-EOS
      grep 127.0.1.2 /etc/hosts || echo 127.0.1.2 g1 >> /etc/hosts
      hostnamectl set-hostname g1
      systemctl restart rsyslog
    EOS
    g1.vm.provision "shell", privileged: true, path: "prov/install_gobgp.sh"
    g1.vm.provision "shell", privileged: true, path: "prov/setup_g1.sh"
  end

  # r2 junos
  config.vm.define :r2 do |r2|
    r2.vm.box = "juniper/ffp-12.1X47-D15.4-packetmode"
    r2.vm.network "private_network", ip: "10.173.176.102",  virtualbox__intnet: "gobgp-101_ix"
    r2.vm.provider "virtualbox" do |v|
      v.memory = 512
    end
  end

  # r3 junos
  config.vm.define :r3 do |r3|
    r3.vm.box = "juniper/ffp-12.1X47-D15.4-packetmode"
    r3.vm.network "private_network", ip: "10.1.1.103", virtualbox__intnet: "gobgp-101_1-to-3"
    r3.vm.provider "virtualbox" do |v|
      v.memory = 512
    end
  end
end
