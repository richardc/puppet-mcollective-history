# private class
class mcollective::client::config {
  mcollective::client::setting { 'libdir':
    value => $mcollective::libdir,
  }
  anchor { 'mcollective::client::config::begin': } ->
  anchor { 'mcollective::client::config::end': }
  class { "mcollective::client::config::connector::${mcollective::connector}": } ->
  class { "mcollective::client::config::securityprovider::${mcollective::securityprovider}": }
}
