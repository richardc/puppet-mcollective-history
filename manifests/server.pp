class mcollective::server {
  # delete any non-managed keys
  resources { 'mcollective_server_setting': purge => true }

  class { "mcollective::server::connector::${mcollective::connector}": }
}
