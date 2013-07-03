# This shouldn't be needed normally
exec { 'create_server_cert':
  command => "/usr/bin/puppet cert generate ${::fqdn}",
  creates => "${settings::ssldir}/certs/${::fqdn}.pem",
} ->
class { 'mcollective':
  activemq_hosts           => [ 'localhost' ],
  server_activemq_password => 'ilikepie',
  server                   => true,
  client                   => true,
  middleware               => true,
}

mcollective::agent { 'rpcutil':
  policy  => 'deny',
}

mcollective::agent::actionpolicy { 'root rpcutil':
  agent    => 'rpcutil',
  callerid => 'cert=root',
}

mcollective::agent { 'nrpe':
  policy  => 'deny',
  package => true,
}

mcollective::agent::actionpolicy { 'root nrpe':
  agent    => 'nrpe',
  callerid => 'cert=root',
}

mcollective::agent::actionpolicy { 'nagios nrpe':
  agent    => 'nrpe',
  callerid => 'cert=nagios',
  actions  => 'runcommand',
}

exec { 'create_nagios_cert':
  command => '/usr/bin/puppet cert generate nagios',
  creates => "${settings::ssldir}/certs/nagios.pem",
} ->
user { 'nagios':
  ensure     => 'present',
  managehome => true,
} ->
mcollective::user { 'nagios':
  certificate => "${settings::ssldir}/certs/nagios.pem",
  private_key => "${settings::ssldir}/private_keys/nagios.pem",
  require     => Class['mcollective::client::config'], # HACK
}

exec { 'create_root_cert':
  command => '/usr/bin/puppet cert generate root',
  creates => "${settings::ssldir}/certs/root.pem",
} ->
mcollective::user { 'root':
  homedir     => '/root',
  certificate => "${settings::ssldir}/certs/root.pem",
  private_key => "${settings::ssldir}/private_keys/root.pem",
  require     => Class['mcollective::client::config'], # HACK
}

mcollective::server::client { 'nagios':
  certificate => "${settings::ssldir}/certs/nagios.pem",
}

mcollective::server::client { 'root':
  certificate => "${settings::ssldir}/certs/root.pem",
}

# and fake install nrpe
file { ['/etc/nagios', '/etc/nagios/nrpe.d']:
  ensure => 'directory',
}

file { '/etc/nagios/nrpe.d/hello_world.cfg':
  content => "command[hello_world]=echo Hello World!\n",
}
