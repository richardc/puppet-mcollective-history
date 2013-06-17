# Class mcollectiver::server::config::securityprovider::psk
class mcollective::server::config::securityprovider::psk {
  mcollective::server::setting { 'securityprovider':
    value => 'psk',
  }

  mcollective::server::setting { 'plugin.psk':
    value => $mcollective::psk,
  }
}
