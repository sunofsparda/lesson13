File { backup => false }

node 'puppet-prod.local' {
  class { 'puppetdb':
    listen_address => '192.168.100.101',  }
  
  class {'::puppetexplorer':
    vhost_options => {
      rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
  }
}