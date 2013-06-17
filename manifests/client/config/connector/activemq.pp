# Class - mcollective::client::config::connector::activemq
class mcollective::client::config::connector::activemq {
  mcollective::client::setting { 'connector':
    value => 'activemq',
  }

  mcollective::client::setting { 'direct_addressing':
    value => 1,
  }

  mcollective::client::setting { 'plugin.activemq.pool.size':
    value => size($mcollective::activemq_hosts),
  }

  # Oh puppet!  Fake iteration of the indexes (+1 as plugin.activemq.pool is
  # 1-based)
  $indexes = range('1', size($mcollective::activemq_hosts))
  mcollective::client::config::connector::activemq::hosts_iteration { $indexes: }
}
