class { 'mcollective':
  activemq_hosts           => [ $::fqdn ],
  server_activemq_password => 'ilikepie',
}

class { 'mcollective::middleware::activemq': } ->
class { 'mcollective::server': }
class { 'mcollective::client': }

mcollective::agent { 'nrpe':
  policy => 'policy default deny
allow uid=0 * * *
allow user=nagios runcommand * *
',
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
  cert_public  => "${settings::ssldir}/public_keys/nagios.pem",
  cert_private => "${settings::ssldir}/private_keys/nagios.pem",
}

# and fake install nrpe
file { ['/etc/nagios', '/etc/nagios/nrpe.d']:
  ensure => 'directory',
}

file { '/etc/nagios/nrpe.d/hello_world.cfg':
  content => "command[hello_world]=echo Hello World!\n",
}
