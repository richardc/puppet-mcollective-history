# private class
class mcollective::server::config::securityprovider::ssl {
  mcollective::server::setting { 'plugin.ssl_client_cert_dir':
    value => '/etc/mcollective/clients',
  }

  mcollective::server::setting { 'plugin.ssl_server_public':
    value => '/etc/mcollective/server_public.pem',
  }

  mcollective::server::setting { 'plugin.ssl_server_private':
    value => '/etc/mcollective/server_private.pem',
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
}
