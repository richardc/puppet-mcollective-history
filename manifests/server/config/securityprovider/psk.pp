# private class
class mcollective::server::config::securityprovider::psk {
  mcollective::server::setting { 'securityprovider':
    value => 'psk',
  }

  mcollective::server::setting { 'plugin.psk':
    value => $mcollective::psk,
  }
}
