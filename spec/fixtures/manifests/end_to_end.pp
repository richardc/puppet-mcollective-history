class { 'mcollective':
  activemq_hosts           => [ $::fqdn ],
  securityprovider         => 'psk',
  server_activemq_password => 'ilikepie',
  server                   => true,
  client                   => true,
  middleware               => true,
}

mcollective::agent { 'nrpe':
  policy       => {
    'default'  => 'deny',
    rules      => [ {
      action   => 'allow',
      callerid => 'uid=0',
    },
    {
      action   => 'allow',
      callerid => 'cert=nagios',
      actions  => 'runcommand',
    },
    ],
  },
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

# and fake install nrpe
file { ['/etc/nagios', '/etc/nagios/nrpe.d']:
  ensure => 'directory',
}

file { '/etc/nagios/nrpe.d/hello_world.cfg':
  content => "command[hello_world]=echo Hello World!\n",
}
