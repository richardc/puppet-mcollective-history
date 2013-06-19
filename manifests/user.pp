# Define - mcollective::user
define mcollective::user(
  $cert_public,
  $cert_private,
  $homedir = "/home/${title}",
) {
  file { "${homedir}/.mcollective.d":
    ensure => 'directory',
  }

  file { "${homedir}/.mcollective.d/user-public.pem":
    source => $cert_public,
    owner  => $name,
    mode   => '0444',
  }

  file { "${homedir}/.mcollective.d/user-private.pem":
    source => $cert_private,
    owner  => $name,
    mode   => '0400',
  }

  file { "${homedir}/.mcollective.conf":
    ensure  => 'file',
    content => template('mcollective/user.cfg.erb'),
  }
}
