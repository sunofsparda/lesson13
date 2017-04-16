#!/bin/bash

grep -q -F '192.168.100.102 puppet-node1' /etc/hosts || echo '192.168.100.102 puppet-node1.minsk.epam.com' >> /etc/hosts

yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppetserver > /dev/null 2>&1
yum install -y nginx > /dev/null 2>&1

cp /vagrant/puppet/site.pp /etc/puppetlabs/code/environments/production/manifests
cp /vagrant/puppet/autosign.conf /etc/puppetlabs/puppet/

systemctl enable puppetserver
systemctl start puppetserver

PATH=/opt/puppetlabs/bin:$PATH;export PATH

# configure PuppetDB server’s firewall to accept incoming connections on port 8081
firewall-cmd --zone=public--add-port=8081/tcp --permanent 
firewall-cmd --reload

# PuppetDB 2.3 » Installing PuppetDB From Packages
puppet resource package puppetdb ensure=latest
puppet resource service puppetdb ensure=running enable=true

# PuppetDB 2.3 » Connecting Puppet Masters to PuppetDB
puppet resource package puppetdb-terminus ensure=latest

# Step 2: Edit Config Files
# Locate Puppet’s Config Directory
# puppet config print confdir