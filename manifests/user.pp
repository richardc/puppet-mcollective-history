define mcollective::user(
  $homedir = "/home/${title}",
  $cert,
) {
  file { "${homedir}/.mcollective.d":
    ensure => 'directory',
  }

  file { "${homedir}/.mcollective.d/user.pem":
    source => $cert,
  }

  file { "${homedir}/.mcollective.conf":
    ensure  => 'file',
    content => template('mcollective/user.cfg.erb'),
  }
}
