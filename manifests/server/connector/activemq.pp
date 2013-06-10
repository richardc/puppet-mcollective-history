# Class - mcollective::server::connector::activemq
class mcollective::server::connector::activemq {
  mcollective_server_setting { 'connector':
    value => 'activemq',
  }

  mcollective_server_setting { 'direct_addressing':
    value => 1,
  }

  mcollective_server_setting { 'plugin.activemq.pool.size':
    value => size($mcollective::activemq_hosts),
  }
}
