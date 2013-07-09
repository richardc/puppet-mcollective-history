# Define - mcollective::user
define mcollective::user(
  $username = $title,
  $ca_certificate = $mcollective::ssl_ca_cert,
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

  # Use order 60 so a user setting (default 70) will override
  mcollective::user::setting { "${username}:plugin.ssl_server_public":
    username => $username,
    value    => '/etc/mcollective/server_public.pem',
    order    => '60',
  }

  mcollective::user::setting { "${username}:plugin.ssl_client_public":
    username => $username,
    value    => "${homedir}/.mcollective.d/credentials/certs/${username}.pem",
    order    => '60',
  }

  mcollective::user::setting { "${username}:plugin.ssl_client_private":
    username => $username,
    value    => "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem",
    order    => '60',
  }

  # XXX this is specific to activemq, but refers to the user's certs
  # Is there a better home for it?  I hope so
  if $mcollective::connector == 'activemq' {
    $connectors = prefix(range( '1', size( $mcollective::activemq_hosts ) ), "${username}_" )
    mcollective::user::activemq { $connectors:
      username => $username,
      homedir  => $homedir,
      order    => '60',
    }
  }
}
