# private class
class mcollective::client::config {
  datacat { 'mcollective::client':
    path     => '/etc/mcollective/client.cfg',
    template => 'mcollective/settings.cfg.erb',
  }

  anchor { 'mcollective::client::config::begin': } ->
  class { "mcollective::client::config::securityprovider::${mcollective::securityprovider}": } ->
  anchor { 'mcollective::client::config::end': }

  $connector_class = "mcollective::client::config::connector::${mcollective::connector}"
  if defined($connector_class) {
    class { $connector_class:
      require => Anchor['mcollective::client::config::begin'],
      before  => Anchor['mcollective::client::config::end'],
    }
  }
}
