# Class mcollectiver::server::securityprovider::psk
class mcollective::server::securityprovider::psk {
  mcollective::server::setting { 'securityprovider':
    value => 'psk',
  }

  mcollective::server::setting { 'plugin.psk':
    value => $mcollective::psk,
  }
}
