ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
IMAGEN = "generic/ubuntu2004"
SERVER = "wire-server.cultura.lab"
CLIENT = "wire-client.cultura.lab"

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/home/vagrant", type: "rsync", disabled: true

  config.vm.define :server do |s|
    s.vm.box = IMAGEN
    s.vm.hostname = SERVER
    s.vm.box_check_update = false

    s.vm.provider :libvirt do |v|
      v.memory = 1024
      v.cpus = 2
    end
  end

  config.vm.define :client do |c|
    c.vm.box = IMAGEN
    c.vm.hostname = CLIENT
    c.vm.box_check_update = false

    c.vm.provider :libvirt do |vb|
      vb.memory = 512
      vb.cpus = 2
    end
  end
end