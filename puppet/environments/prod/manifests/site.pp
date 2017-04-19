File { backup => false }

node 'node.lab' {
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
