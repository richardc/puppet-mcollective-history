# private define
define mcollective::user::connector($username, $homedir, $order) {
  $i = regsubst($title, "^${username}_", '')

  mcollective::user::setting { "${username} plugin.${mcollective::connector}.pool.${i}.ssl.ca":
    username => $username,
    order    => $order,
    value    => "${homedir}/.mcollective.d/credentials/certs/ca.pem",
  }

  mcollective::user::setting { "${username} plugin.${mcollective::connector}.pool.${i}.ssl.cert":
    username => $username,
    order    => $order,
    value    => "${homedir}/.mcollective.d/credentials/certs/${username}.pem",
  }

  mcollective::user::setting { "${username} plugin.${mcollective::connector}.pool.${i}.ssl.key":
    username => $username,
    order    => $order,
    value    => "${homedir}/.mcollective.d/credentials/private_keys/${username}.pem",
  }
}
