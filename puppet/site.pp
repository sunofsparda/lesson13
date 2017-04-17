# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  notify { "Node ${::fqdn} is up and running!": }
}

node 'puppet-node1' {
  class { 'nginx': }
  class { '::mysql::server':
    root_password => 'password',
  }

  mysql_database { 'prod_mdb':
    ensure  =>  present,
    charset =>  'utf8',
  }

  mysql_user { 'prod_user@localhost':
    ensure  =>  present,
    password_hash =>  mysql_password('prod_password'),
  }

  mysql_grant { 'prod_user@localhost/prod_mdb.*':
    ensure  =>  present,
    options =>  ['GRANT'],
    privileges  =>  ['ALL'],
    table =>  'prod_mdb.*',
    user  =>  'prod_user@localhost',
  }
}