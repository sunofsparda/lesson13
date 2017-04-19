grep -q -F '192.168.100.101 server.lab' /etc/hosts || echo '192.168.100.101 server.lab' >> /etc/hosts
grep -q -F '192.168.100.102 node.lab' /etc/hosts || echo '192.168.100.102 node.lab' >> /etc/hosts

yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppet-agent > /dev/null 2>&1

/bin/cp /vagrant/puppet/puppet_conf.node /etc/puppetlabs/puppet/puppet.conf
# source ~/.bashrc
puppet agent -t --verbose

echo 'provisioned'
exit 0
