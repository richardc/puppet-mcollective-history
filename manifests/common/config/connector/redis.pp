# Private class
class mcollective::common::config::connector::redis {
  mcollective::setting { 'mcollective::common connector':
    setting => 'connector',
    target  => [ 'mcollective::server', 'mcollective::client' ],
    value   => 'redis',
  }

  # Redis connector only uses one host to connect to.  Assume that the first will
  # be OK
  mcollective::setting { 'mcollective::common plugin.redis.host':
    setting => 'plugin.redis.host',
    target  => [ 'mcollective::server', 'mcollective::client' ],
    value   => $mcollective::middleware_hosts[0],
  }

  mcollective::plugin { 'mcollective::server::config::connector::redis':
    source_path => 'puppet:///modules/mcollective_plugin_redis/lib',
  }

  package { 'rubygem-redis':
    ensure => installed,
  }
}
