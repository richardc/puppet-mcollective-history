# This shouldn't be needed normally
exec { 'create_server_cert':
  command => "/usr/bin/puppet cert generate ${::fqdn}",
  creates => "${settings::ssldir}/certs/${::fqdn}.pem",
} ->
class { 'mcollective':
  activemq_hosts           => [ $::fqdn ],
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
  callerid => 'cert=root-public',
}

mcollective::agent { 'nrpe':
  policy  => 'deny',
  package => true,
}

mcollective::agent::actionpolicy { 'root nrpe':
  agent    => 'nrpe',
  callerid => 'cert=root-public',
}

mcollective::agent::actionpolicy { 'nagios nrpe':
  agent    => 'nrpe',
  callerid => 'cert=nagios-public',
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
  require      => Class['mcollective'],
  cert_public  => "${settings::ssldir}/public_keys/nagios.pem",
  cert_private => "${settings::ssldir}/private_keys/nagios.pem",
}

exec { 'create_root_cert':
  command => '/usr/bin/puppet cert generate root',
  creates => "${settings::ssldir}/certs/root.pem",
} ->
mcollective::user { 'root':
  homedir      => '/root',
  cert_public  => "${settings::ssldir}/public_keys/root.pem",
  cert_private => "${settings::ssldir}/private_keys/root.pem",
  require      => Class['mcollective'],
}

mcollective::server::client { 'nagios':
  cert_public  => "${settings::ssldir}/public_keys/nagios.pem",
  cert_private => "${settings::ssldir}/private_keys/nagios.pem",
}

mcollective::server::client { 'root':
  cert_public  => "${settings::ssldir}/public_keys/root.pem",
  cert_private => "${settings::ssldir}/private_keys/root.pem",
}

# and fake install nrpe
file { ['/etc/nagios', '/etc/nagios/nrpe.d']:
  ensure => 'directory',
}

file { '/etc/nagios/nrpe.d/hello_world.cfg':
  content => "command[hello_world]=echo Hello World!\n",
}
