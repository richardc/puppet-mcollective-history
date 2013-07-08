# Define - mcollective::user
define mcollective::user(
  $username = $title,
  $ca_certificate = "${settings::ssldir}/certs/ca.pem",
  $certificate = undef,
  $private_key = undef,
  $homedir = "/home/${title}",
  $settings = {},
) {
  file { [
    "${homedir}/.mcollective.d",
    "${homedir}/.mcollective.d/credentials",
    "${homedir}/.mcollective.d/credentials/certs",
    "${homedir}/.mcollective.d/credentials/private_keys"
  ]:
    ensure => 'directory',
  }

  file { "${homedir}/.mcollective.d/credentials/certs/ca.pem":
    source => $ca_certificate,
    owner  => $name,
    mode   => '0444',
  }

  if $certificate {
    file { "${homedir}/.mcollective.d/credentials/certs/${username}.pem":
      source => $certificate,
      owner  => $name,
      mode   => '0444',
    }
  }

  if $private_key {
    $private_path = "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem"
    file { $private_path:
      source => $private_key,
      owner  => $name,
      mode   => '0400',
    }
  }

  datacat { "mcollective::user ${username}":
    path     => "${homedir}/.mcollective",
    collects => [ 'mcollective::user', 'mcollective::client' ],
    owner    => $username,
    template => 'mcollective/settings.cfg.erb',
  }

  datacat_fragment { "mcollective::user ${username} defaults":
    target => "mcollective::user ${username}",
    order  => '70',
    data   => {
      'plugin.ssl_server_public'  => '/etc/mcollective/server_public.pem',
      'plugin.ssl_client_public'  => "${homedir}/.mcollective.d/credentials/certs/${username}.pem",
      'plugin.ssl_client_private' => "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem",
    },
  }

  # XXX for activemq?
  if $mcollective::connector == 'activemq' {
    $connectors = prefix(range( '1', size( $mcollective::activemq_hosts ) ), "${username}_" )
    mcollective::user::activemq { $connectors:
      username => $username,
      homedir  => $homedir,
    }
  }

  datacat_fragment { "mcollective::user ${username} user override":
    target => "mcollective::user ${username}",
    order  => '80',
    data   => $settings,
  }
}
