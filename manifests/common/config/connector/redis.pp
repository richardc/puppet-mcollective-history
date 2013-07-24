# Private class
class mcollective::common::config::connector::redis {
  # Redis connector only uses one host to connect to.  Assume that the first will
  # be OK
  mcollective::common::setting { 'plugin.redis.host':
    value => $mcollective::middleware_hosts[0],
  }

  mcollective::plugin { 'mcollective::server::config::connector::redis':
    source_path => 'puppet:///modules/mcollective_plugin_redis/lib',
  }

  package { 'rubygem-redis':
    ensure => installed,
  }
}
