# Class - mcollective::client::config
class mcollective::client::config {
  mcollective::client::setting { 'libdir':
    value => $mcollective::libdir,
  }

  class { "mcollective::client::config::connector::${mcollective::connector}": } ->
  class { "mcollective::client::config::securityprovider::${mcollective::securityprovider}": }
}
