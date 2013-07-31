# private class
class mcollective::server::config {
  datacat { 'mcollective::server':
    path     => '/etc/mcollective/server.cfg',
    template => 'mcollective/settings.cfg.erb',
  }

  mcollective::server::setting { 'daemonize':
    value => $mcollective::server_daemonize,
  }

  mcollective::server::setting { 'logfile':
    value => $mcollective::server_logfile,
  }

  mcollective::server::setting { 'loglevel':
    value => $mcollective::server_loglevel,
  }

  file { '/etc/mcollective/policies':
    ensure => 'directory',
  }

  file { '/etc/mcollective/clients':
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    mode    => '0444',
    source  => $mcollective::ssl_client_certs,
  }

  mcollective::soft_include { [
    "::mcollective::server::config::connector::${mcollective::connector}",
    "::mcollective::server::config::securityprovider::${mcollective::securityprovider}",
    "::mcollective::server::config::factsource::${mcollective::factsource}",
    "::mcollective::server::config::registration::${mcollective::registration}",
    "::mcollective::server::config::rpcauditprovider::${mcollective::rpcauditprovider}",
    "::mcollective::server::config::rpcauthprovider::${mcollective::rpcauthprovider}",
  ]:
    start => Anchor['mcollective::server::config::begin'],
    end   => Anchor['mcollective::server::config::end'],
  }

  anchor { 'mcollective::server::config::begin': }
  anchor { 'mcollective::server::config::end': }
}
