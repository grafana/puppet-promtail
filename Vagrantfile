Vagrant.configure('2') do |config|
  config.vm.box = 'genebean/centos-7-puppet-latest'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.provision 'shell', inline: <<-SCRIPT
    puppet resource file /etc/puppetlabs/code/environments/production/modules/promtail ensure=link target=/vagrant force=true
    /opt/puppetlabs/puppet/bin/gem install puppet-moddeps
    /opt/puppetlabs/puppet/bin/puppet-moddeps promtail
  SCRIPT
end
