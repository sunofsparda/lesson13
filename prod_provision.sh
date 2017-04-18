#!/bin/bash

grep -q -F '192.168.100.101 puppet-prod.local' /etc/hosts || echo '192.168.100.101 puppet-prod.local puppet-prod.local.minsk.epam.com' >> /etc/hosts
grep -q -F '192.168.100.102 puppet-node1.local' /etc/hosts || echo '192.168.100.102 puppet-node1.local puppet-node1.local.minsk.epam.com' >> /etc/hosts


yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppetserver > /dev/null 2>&1


/bin/cp /vagrant/puppet/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
/bin/cp /vagrant/puppet/autosign.conf /etc/puppetlabs/puppet/autosign.conf
/bin/cp /vagrant/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf
/bin/cp /vagrant/puppet/puppetdb.conf /etc/puppetlabs/puppet/puppetdb.conf


mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
/bin/cp /vagrant/puppet/environments/prod/manifests/site.pp /etc/puppetlabs/code/environments/prod/manifests/site.pp


systemctl enable puppetserver
systemctl restart puppetserver


PATH=/opt/puppetlabs/bin:$PATH;export PATH


iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
systemctl restart iptables


# PuppetDB » Connecting Puppet Masters to PuppetDB
puppet resource package puppetdb-terminus ensure=latest


# PuppetDB » Installing PuppetDB From Packages
puppet module install puppetlabs-apache --version 1.11.0
puppet module install puppetlabs-puppetdb --version 5.1.2
puppet module install spotify-puppetexplorer --version 1.1.1


# For env: prod
puppet module install puppet-nginx --version 0.6.0 --environment prod
puppet module install puppetlabs-mysql --version 3.10.0 --environment prod


puppet agent -t --verbose --debug


echo 'provisioned'
exit 0
