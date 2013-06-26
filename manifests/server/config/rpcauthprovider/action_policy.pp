# private class
class mcollective::server::config::rpcauthprovider::action_policy {
  # XXX feels hacky to distribute the actionpolicy.rb with the module, but it's
  # not a package yet
  file { "${mcollective::libdir}/mcollective/util":
    ensure => 'directory',
  }

  file { "${mcollective::libdir}/mcollective/util/actionpolicy.ddl":
    source => 'puppet:///modules/mcollective/actionpolicy.ddl',
  }

  file { "${mcollective::libdir}/mcollective/util/actionpolicy.rb":
    source => 'puppet:///modules/mcollective/actionpolicy.rb',
  }

  mcollective::server::setting { 'rpcauthorization':
    value => 1,
  }

  mcollective::server::setting { 'rpcauthprovider':
    value => 'action_policy',
  }

  mcollective::server::setting { 'plugin.actionpolicy.allow_unconfigured':
    value => 1,
  }
}
