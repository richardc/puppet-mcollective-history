# private class
class mcollective::client::config {
  anchor { 'mcollective::client::config::begin': } ->
  datacat { 'mcollective::client':
    path     => '/etc/mcollective/client.cfg',
    template => 'mcollective/settings.cfg.erb',
  } ->
  mcollective::client::setting { 'libdir':
    value => $mcollective::libdir,
  } ->
  class { "mcollective::client::config::connector::${mcollective::connector}": } ->
  class { "mcollective::client::config::securityprovider::${mcollective::securityprovider}": } ->
  anchor { 'mcollective::client::config::end': }
}
