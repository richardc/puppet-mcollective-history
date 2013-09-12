# Define - mcollective::user
define mcollective::user(
  $username = $title,
  $ssl_ca_cert = $mcollective::ssl_ca_cert,
  $ssl_server_public = $mcollective::ssl_server_public,
  $certificate = undef,
  $private_key = undef,
  $homedir = "/home/${title}",
) {
  file { [
    "${homedir}/.mcollective.d",
    "${homedir}/.mcollective.d/credentials",
    "${homedir}/.mcollective.d/credentials/certs",
    "${homedir}/.mcollective.d/credentials/private_keys"
  ]:
    ensure => 'directory',
  }

  datacat { "mcollective::user ${username}":
    path     => "${homedir}/.mcollective",
    collects => [ 'mcollective::user', 'mcollective::client' ],
    owner    => $username,
    template => 'mcollective/settings.cfg.erb',
  }

  file { "${homedir}/.mcollective.d/credentials/certs/ca.pem":
    source => $ssl_ca_cert,
    owner  => $name,
    mode   => '0444',
  }

  file { "${homedir}/.mcollective.d/credentials/certs/server_public.pem":
    source => $ssl_server_public,
    owner  => $name,
    mode   => '0444',
  }

  mcollective::user::setting { "${username}:plugin.ssl_server_public":
    username => $username,
    value    => "${homedir}/.mcollective.d/credentials/certs/server_public.pem",
    order    => '60',
  }

  if $certificate {
    file { "${homedir}/.mcollective.d/credentials/certs/${username}.pem":
      source => $certificate,
      owner  => $name,
      mode   => '0444',
    }

    mcollective::user::setting { "${username}:plugin.ssl_client_public":
      username => $username,
      value    => "${homedir}/.mcollective.d/credentials/certs/${username}.pem",
      order    => '60',
    }
  }

  if $private_key {
    $private_path = "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem"
    file { $private_path:
      source => $private_key,
      owner  => $name,
      mode   => '0400',
    }

    mcollective::user::setting { "${username}:plugin.ssl_client_private":
      username => $username,
      value    => "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem",
      order    => '60',
    }
  }

  # XXX this is specific to activemq, but refers to the user's certs
  # Is there a better home for it?  I hope so
  if $mcollective::connector in [ 'activemq', 'rabbitmq' ] {
    $connectors = prefix(range( '1', size( $mcollective::middleware_hosts_real ) ), "${username}_" )
    mcollective::user::connector { $connectors:
      username => $username,
      homedir  => $homedir,
      order    => '60',
    }
  }
}
