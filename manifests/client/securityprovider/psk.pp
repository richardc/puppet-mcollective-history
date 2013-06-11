# Class mcollectiver::client::securityprovider::psk
class mcollective::client::securityprovider::psk {
  mcollective::client::setting { 'securityprovider':
    value => 'psk',
  }

  mcollective::client::setting { 'plugin.psk':
    value => $mcollective::psk,
  }
}
