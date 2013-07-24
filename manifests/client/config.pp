# private class
class mcollective::client::config {
  datacat { 'mcollective::client':
    path     => '/etc/mcollective/client.cfg',
    template => 'mcollective/settings.cfg.erb',
  }

  mcollective::soft_include { [
    "mcollective::client::config::connector::${mcollective::connector}",
    "mcollective::client::config::securityprovider::${mcollective::securityprovider}",
  ]:
    start => Anchor['mcollective::client::config::begin'],
    end   => Anchor['mcollective::client::config::end'],
  }

  anchor { 'mcollective::client::config::begin': }
  anchor { 'mcollective::client::config::end': }
}
