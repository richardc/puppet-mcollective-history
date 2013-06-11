# Class - mcollective::server::connector::activemq
class mcollective::server::connector::activemq {
  mcollective::server::setting { 'connector':
    value => 'activemq',
  }

  mcollective::server::setting { 'direct_addressing':
    value => 1,
  }

  mcollective::server::setting { 'plugin.activemq.pool.size':
    value => size($mcollective::activemq_hosts),
  }
}
