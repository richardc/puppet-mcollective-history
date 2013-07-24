# private class
class mcollective::server::config::rpcauthprovider::action_policy {
  mcollective::plugin { 'actionpolicy': }

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
