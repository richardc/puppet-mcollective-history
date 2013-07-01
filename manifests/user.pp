# Define - mcollective::user
define mcollective::user(
  $username = $title,
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

  concat { "${homedir}/.mcollective":
    owner => $name,
  }

  concat::fragment { "mcollective::user ${name} global":
    ensure  => '/etc/mcollective/client.cfg',
    order   => '10',
    target  => "${homedir}/.mcollective",
  }

  concat::fragment { "mcollective::user ${name}":
    order   => '20',
    target  => "${homedir}/.mcollective",
    content => template('mcollective/user.cfg.erb'),
  }
}
