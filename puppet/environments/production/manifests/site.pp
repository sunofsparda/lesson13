node 'server.lab' {
  # # Configure puppetdb
  class { 'puppetdb::server':
    database_host => '127.0.0.1',
    confdir =>  '/etc/puppetlabs/puppetdb/conf.d',
   }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
  class {'::puppetexplorer':
    vhost_options => {
      rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
    }
}
