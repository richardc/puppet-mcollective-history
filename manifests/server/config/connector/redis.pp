class mcollective::server::config::connector::redis {
  mcollective::server::setting { 'connector':
    value => 'redis',
  }

  # Redis connector only uses one host to connect to.  Assume that the first will
  # be OK
  mcollective::server::setting { 'plugin.redis.host':
    value => $mcollective::middleware_hosts[0],
  }
}
