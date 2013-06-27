# Define - mcollective::user
define mcollective::user(
  $username = $title,
  $cert_public = undef,
  $cert_private = undef,
  $homedir = "/home/${title}",
) {
  file { "${homedir}/.mcollective.d":
    ensure => 'directory',
  }

  if $cert_public {
    file { "${homedir}/.mcollective.d/${username}-public.pem":
      source => $cert_public,
      owner  => $name,
      mode   => '0444',
    }
  }

  if $cert_private {
    file { "${homedir}/.mcollective.d/${username}-private.pem":
      source => $cert_private,
      owner  => $name,
      mode   => '0400',
    }
  }

  concat { "${homedir}/.mcollective":
    owner => $name,
  }

  concat::fragment { "mcollective::user ${name} global":
    ensure => '/etc/mcollective/client.cfg',
    order  => '10',
    target => "${homedir}/.mcollective",
  }

  concat::fragment { "mcollective::user ${name}":
    order   => '20',
    target  => "${homedir}/.mcollective",
    content => template('mcollective/user.cfg.erb'),
  }
}
