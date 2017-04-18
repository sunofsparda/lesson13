File { backup => false }

node 'puppet-prod.local.minsk.epam.com' {
  class { 'puppetdb': }
  class { 'puppetdb::master::config': }
  
  class {'::puppetexplorer':
    vhost_options => {
      rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
  }
}