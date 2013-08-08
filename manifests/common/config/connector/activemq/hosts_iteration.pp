# private define
# $name will be an index into the $mcollective::middleware_hosts array + 1
define mcollective::common::config::connector::activemq::hosts_iteration {
  mcollective::common::setting { "plugin.activemq.pool.${name}.host":
    value => $mcollective::middleware_hosts[$name - 1], # puppet array 0-based
  }

  mcollective::common::setting { "plugin.activemq.pool.${name}.port":
    value => 61614,
  }

  mcollective::common::setting { "plugin.activemq.pool.${name}.user":
    value => $mcollective::server_activemq_user,
  }

  mcollective::common::setting { "plugin.activemq.pool.${name}.password":
    value => $mcollective::server_activemq_password,
  }

  if $mcollective::middleware_ssl {
    mcollective::common::setting { "plugin.activemq.pool.${name}.ssl":
      value => 1,
    }

    mcollective::common::setting { "plugin.activemq.pool.${name}.ssl.ca":
      value => '/etc/mcollective/ca.pem',
    }

    mcollective::common::setting { "plugin.activemq.pool.${name}.ssl.fallback":
      value => 0,
    }
  }
}