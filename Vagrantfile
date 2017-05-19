Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'schooltool.loc'
  config.vm.network 'private_network', ip: '192.168.33.13'

  config.vm.provider :virtualbox do |vb|
    vb.name = 'vSchoolTool'
    vb.cpus   = 1
    vb.memory = 1024
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
  end

  config.vm.provision :puppet do |puppet|
    puppet.options        = '--verbose --summarize --debug'
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
  end
end
