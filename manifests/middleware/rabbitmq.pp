#
class mcollective::middleware::rabbitmq {
  class { '::rabbitmq':
    erlang_manage     => true,
    config_stomp      => true,
    stomp_port        => $mcollective::middleware_port,
  }

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
    # needs a restart to enable
    notify => Class['::rabbitmq::service'],
  }

  rabbitmq_vhost { $mcollective::middleware_vhost:
    ensure => present,
  }

  # it's not ideal that this user is an admin, but we need one in order to
  # create the exchange. XXX maybe add another user for that
  rabbitmq_user { $mcollective::middleware_user:
    ensure   => present,
    admin    => true,
    password => $mcollective::middleware_password,
  }

  rabbitmq_user_permissions { "${mcollective::middleware_user}@${mcollective::middleware_vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_exchange { "mcollective_broadcast@${mcollective::middleware_vhost}":
    ensure   => present,
    type     => 'topic',
    user     => $mcollective::middleware_user,
    password => $mcollective::middleware_password,
  }

  rabbitmq_exchange { "mcollective_directed@${mcollective::middleware_vhost}":
    ensure   => present,
    type     => 'direct',
    user     => $mcollective::middleware_user,
    password => $mcollective::middleware_password,
  }
}
