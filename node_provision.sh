#!/bin/bash

grep -q -F '192.168.100.101 puppet-prod.local' /etc/hosts || echo '192.168.100.101 puppet-prod.local puppet-prod.local.minsk.epam.com' >> /etc/hosts
grep -q -F '192.168.100.102 puppet-node1.local' /etc/hosts || echo '192.168.100.102 puppet-node1.local puppet-node1.local.minsk.epam.com' >> /etc/hosts

yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppet-agent > /dev/null 2>&1

# PATH=/opt/puppetlabs/bin:$PATH;export PATH
# puppet resource package puppet ensure=latest

systemctl stop iptables
systemctl stop firewalld
systemctl disable iptables
systemctl disable firewalld

/bin/cp /vagrant/puppet/puppet_conf.node /etc/puppetlabs/puppet/puppet.conf


PATH=/opt/puppetlabs/bin:$PATH;export PATH
puppet agent --test --verbose # --debug

echo 'test'
exit 0
