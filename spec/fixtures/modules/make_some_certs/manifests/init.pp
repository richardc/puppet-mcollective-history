#
class make_some_certs {
  # This should lexically scope this resource default.
  # On some vagrant vms puppet isn't in /etc/bin/puppet
  Exec {
    path => [ '/usr/bin', '/opt/ruby/bin' ]
  }

  # This shouldn't be needed normally but will be in a vagrant env
  exec { 'create_server_cert':
    command => "puppet cert generate ${::fqdn}",
    creates => "${settings::ssldir}/certs/${::fqdn}.pem",
  }
  exec { 'create_nagios_cert':
    command => 'puppet cert generate nagios',
    creates => "${settings::ssldir}/certs/nagios.pem",
  }
  exec { 'create_root_cert':
    command => 'puppet cert generate root',
    creates => "${settings::ssldir}/certs/root.pem",
  }
}
