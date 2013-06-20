# Class mcollectiver::server::config::securityprovider::ssl
class mcollective::server::config::securityprovider::ssl {
  mcollective::server::setting { 'securityprovider':
    value => 'ssl',
  }

  mcollective::server::setting { 'plugin.ssl_client_cert_dir':
    value => '/etc/mcollective/clients',
  }

  mcollective::server::setting { 'plugin.ssl_server_public':
    value => '/etc/mcollective/server_public.pem',
  }

  mcollective::server::setting { 'plugin.ssl_server_private':
    value => '/etc/mcollective/server_private.pem',
  }

  file { '/etc/mcollective/server_public.pem':
    source => $mcollective::server_public_pem,
  }

  file { '/etc/mcollective/server_private.pem':
    source => $mcollective::server_private_pem,
  }
}
