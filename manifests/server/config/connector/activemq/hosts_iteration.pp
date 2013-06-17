# Define - mcollective::server::config::connector::activemq::iteration
# $name will be an index into the $mcollective::activemq_hosts array + 1
define mcollective::server::config::connector::activemq::hosts_iteration {
  mcollective::server::setting { "plugin.activemq.pool.${name}.host":
    value => $mcollective::activemq_hosts[$name - 1], # puppet array 0-based
  }

  mcollective::server::setting { "plugin.activemq.pool.${name}.port":
    value => 61614,
  }

  mcollective::server::setting { "plugin.activemq.pool.${name}.user":
    value => $mcollective::server_activemq_user,
  }

  mcollective::server::setting { "plugin.activemq.pool.${name}.password":
    value => $mcollective::server_activemq_password,
  }
}
