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
      value => "${settings::ssldir}/certs/ca.pem",
    }

    # We might not want this for the global settings at all, or will we want a
    # mode where we're setting up a ssl transport but with a global 'server'
    # cert.
    # When we set this up for a user we use ~/.mcollective.d/credentials/certs/${username}.pem
    # so for our current testing don't set this up globally
    #mcollective::client::setting { "plugin.activemq.pool.${name}.ssl.cert":
    # value => '',
    #}

    # Same noodlings for the .ssl.cert
    #mcollective::client::setting { "plugin.activemq.pool.${name}.ssl.key":
    #  value => $mcollective::server_activemq_password,
    #}

    mcollective::client::setting { "plugin.activemq.pool.${name}.ssl.fallback":
      value => 0,
    }
  }
}
