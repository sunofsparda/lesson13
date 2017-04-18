#!/bin/bash

grep -q -F '192.168.100.101 puppet-server' /etc/hosts || echo '192.168.100.101 puppet-server' >> /etc/hosts
grep -q -F '192.168.100.102 puppet-node1' /etc/hosts || echo '192.168.100.102 puppet-node1' >> /etc/hosts


yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppet-agent > /dev/null 2>&1


/bin/cp /vagrant/puppet/puppet_conf.node /etc/puppetlabs/puppet/puppet.conf


PATH=/opt/puppetlabs/bin:$PATH;export PATH

puppet agent --test --verbose --debug


echo 'provisioned'
exit 0
