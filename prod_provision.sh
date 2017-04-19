grep -q -F '192.168.100.101 server.lab' /etc/hosts || echo '192.168.100.101 server.lab' >> /etc/hosts
grep -q -F '192.168.100.102 node.lab' /etc/hosts || echo '192.168.100.102 node.lab' >> /etc/hosts

yum install -y epel-release > /dev/null 2>&1
yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm > /dev/null 2>&1
yum install -y puppetserver > /dev/null 2>&1
yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm

/bin/cp /vagrant/puppet/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
/bin/cp /vagrant/puppet/autosign.conf /etc/puppetlabs/puppet/autosign.conf
/bin/cp /vagrant/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf

mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
/bin/cp /vagrant/puppet/environments/prod/manifests/site.pp /etc/puppetlabs/code/environments/prod/manifests/site.pp
# /bin/cp /vagrant/puppet/puppetdb.conf /etc/puppetlabs/puppet/puppetdb.conf

systemctl enable puppetserver
systemctl restart puppetserver

setsebool -P httpd_can_network_connect on

#source ~/.bashrc

yum install postgresql94-server postgresql94-contrib -y
/usr/pgsql-9.4/bin/postgresql94-setup initdb
/bin/cp /vagrant/puppet/pg_hba.conf /var/lib/pgsql/9.4/data/

systemctl enable postgresql-9.4.service
systemctl start postgresql-9.4.service

cd /
sudo -u postgres psql -c "create user puppetdb password 'puppetdb'"
sudo -u postgres psql -c "create database puppetdb owner puppetdb"

puppet module install puppetlabs-puppetdb --version 5.1.2
puppet module install puppetlabs-mysql --version 3.10.0 --environment prod
puppet module install puppetlabs-apache --version 1.11.0
puppet module install spotify-puppetexplorer --version 1.1.1
puppet module install puppet-nginx --version 0.6.0 --environment prod

# PuppetDB » Connecting Puppet Masters to PuppetDB
puppet resource package puppetdb-terminus ensure=latest

puppet agent -t --verbose
systemctl stop iptables

echo 'provisioned'
exit 0
