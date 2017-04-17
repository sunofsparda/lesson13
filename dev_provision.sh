#!/bin/bash

grep -q -F '192.168.100.102 puppet-node1' /etc/hosts || echo '192.168.100.102 puppet-node1' >> /etc/hosts

yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppetserver > /dev/null 2>&1
yum install -y nginx > /dev/null 2>&1

/bin/cp /vagrant/puppet/site_pp.prod /etc/puppetlabs/code/environments/production/manifests/site.pp
/bin/cp /vagrant/puppet/autosign.conf /etc/puppetlabs/puppet/autosign.conf
/bin/cp /vagrant/puppet/puppet_conf.prod /etc/puppetlabs/puppet/puppet.conf

systemctl enable puppetserver
systemctl start puppetserver

yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
yum install -y postgresql94-server postgresql94-contrib
/usr/pgsql-9.4/bin/postgresql94-setup initdb
/bin/cp /vagrant/puppet/pg_hba.conf /var/lib/pgsql/9.4/data/
systemctl enable postgresql-9.4.service
systemctl start postgresql-9.4.service
sudo -u postgres psql -c "create user puppetdb password 'puppetdb'"
sudo -u postgres psql -c "create database puppetdb owner puppetdb"

PATH=/opt/puppetlabs/bin:$PATH;export PATH

# configure PuppetDB server’s firewall to accept incoming connections on port 8081
firewall-cmd --zone=public--add-port=8081/tcp --permanent 
firewall-cmd --reload

# PuppetDB » Connecting Puppet Masters to PuppetDB
puppet resource package puppetdb-terminus ensure=latest

# PuppetDB » Installing PuppetDB From Packages
puppet module install puppetlabs-puppetdb --version 5.1.2
puppet module install puppetlabs-mysql --version 3.10.0 --environment production
puppet module install puppetlabs-apache --version 1.11.0
puppet module install spotify-puppetexplorer --version 1.1.1
puppet module install puppet-nginx --version 0.6.0 --environment production
puppet agent -t --verbose