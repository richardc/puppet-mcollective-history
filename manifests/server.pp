class mcollective::server {
  # delete any non-managed keys
  resources { 'mcollective_server_setting': purge => true }

  anchor { 'mcollective::server::begin': } ->
  class { 'mcollective::server::install': } ->
  class { "mcollective::server::connector::${mcollective::connector}": } ->
  class { "mcollective::server::securityprovider::${mcollective::securityprovider}": } ->
  class { 'mcollective::server::service': } ->
  anchor { 'mcollectve::server::end': }
}
