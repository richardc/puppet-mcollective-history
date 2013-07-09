# private define
# $name will be an index into the $mcollective::activemq_hosts array + 1
define mcollective::client::config::connector::activemq::hosts_iteration {
  mcollective::client::setting { "plugin.activemq.pool.${name}.host":
    value => $mcollective::activemq_hosts[$name - 1], # puppet array 0-based
  }

  mcollective::client::setting { "plugin.activemq.pool.${name}.port":
    value => 61614,
  }

  # XXX this is just reusing *server* credentials - wrong-o
  mcollective::client::setting { "plugin.activemq.pool.${name}.user":
    value => $mcollective::server_activemq_user,
  }

  mcollective::client::setting { "plugin.activemq.pool.${name}.password":
    value => $mcollective::server_activemq_password,
  }

  if $mcollective::middleware_ssl {
    mcollective::client::setting { "plugin.activemq.pool.${name}.ssl":
      value => 1,
    }

    mcollective::client::setting { "plugin.activemq.pool.${name}.ssl.ca":
      value => '/etc/mcollective/ca.pem',
    }

    mcollective::client::setting { "plugin.activemq.pool.${name}.ssl.fallback":
      value => 0,
    }
  }
}
