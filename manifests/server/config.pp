# Class - mcollective::server::config
class mcollective::server::config {
  mcollective::server::setting { 'libdir':
    value => $mcollective::libdir,
  }

  mcollective::server::setting { 'daemonize':
    value => $mcollective::server_daemonize,
  }

  anchor { 'mcollective::server::config::begin': } ->
  class { "mcollective::server::config::connector::${mcollective::connector}": } ->
  class { "mcollective::server::config::securityprovider::${mcollective::securityprovider}": } ->
  anchor { 'mcollective::server::config::end': }
}
