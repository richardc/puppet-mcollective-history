class site_nagios::server {
  user { 'nagios':
    ensure       => 'present',
    managehome => true,
  } ->
  mcollective::user { 'nagios':
    certificate   => "${settings::ssldir}/certs/nagios.pem",
    private_key => "${settings::ssldir}/private_keys/nagios.pem",
  }

}
