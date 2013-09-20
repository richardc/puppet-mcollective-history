# private class
class mcollective::server::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  datacat { 'mcollective::server':
    path     => $mcollective::server_config_file,
    template => 'mcollective/settings.cfg.erb',
  }

  mcollective::server::setting { 'classesfile':
    value => $mcollective::classesfile,
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

  file { '/etc/mcollective/ca.pem':
    source => $mcollective::ssl_ca_cert,
    mode   => '0444',
  }

  file { '/etc/mcollective/server_public.pem':
    source => $mcollective::ssl_server_public,
    mode   => '0444',
  }

  file { '/etc/mcollective/server_private.pem':
    source => $mcollective::ssl_server_private,
    mode   => '0400',
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
