# Class - mcollective::server::config
class mcollective::server::config {
  mcollective::server::setting { 'libdir':
    value => $mcollective::libdir,
  }

  mcollective::server::setting { 'daemonize':
    value => $mcollective::server_daemonize,
  }

  file { '/etc/mcollective/policies':
    ensure => 'directory',
  }

  anchor { 'mcollective::server::config::begin': } ->
  class { "mcollective::server::config::connector::${mcollective::connector}": } ->
  class { "mcollective::server::config::securityprovider::${mcollective::securityprovider}": } ->
  class { "mcollective::server::config::factsource::${mcollective::factsource}": } ->
  class { "mcollective::server::config::rpcauthprovider::${mcollective::rpcauthprovider}": } ->
  anchor { 'mcollective::server::config::end': }
}
