#
class mcollective::middleware::rabbitmq {
  if $mcollective::middleware_ssl {
    file { "${mcollective::rabbitmq_confdir}/ca.pem":
      source => $mcollective::ssl_ca_cert,
    }

    file { "${mcollective::rabbitmq_confdir}/server_public.pem":
      source => $mcollective::ssl_server_public,
    }

    file { "${mcollective::rabbitmq_confdir}/server_private.pem":
      source => $mcollective::ssl_server_private,
    }
  }

  class { '::rabbitmq':
    erlang_manage  => true,
    config_stomp   => true,
    ssl            => $mcollective::middleware_ssl,
    stomp_port     => $mcollective::middleware_port,
    ssl_stomp_port => $mcollective::middleware_ssl_port,
    ssl_cacert     => "${mcollective::rabbitmq_confdir}/ca.pem",
    ssl_cert       => "${mcollective::rabbitmq_confdir}/server_public.pem",
    ssl_key        => "${mcollective::rabbitmq_confdir}/server_private.pem",
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
