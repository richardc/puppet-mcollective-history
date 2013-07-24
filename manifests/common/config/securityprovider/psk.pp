# private class
class mcollective::common::config::securityprovider::psk {
  mcollective::common::setting { 'plugin.psk':
    value => $mcollective::psk,
  }
}
