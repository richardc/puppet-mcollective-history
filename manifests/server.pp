class mcollective::server {
  # delete any non-managed keys
  resources { 'mcollective_server_setting': purge => true }
}
