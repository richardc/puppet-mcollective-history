# Class mcollective::client::config::securityprovider::ssl
class mcollective::client::config::securityprovider::ssl {
  mcollective::client::setting { 'securityprovider':
    value => 'ssl',
  }
  # Nothing else to really say globally.  Hrm.
}
