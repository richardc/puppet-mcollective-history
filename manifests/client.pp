class mcollective::client {
  # delete any non-managed keys
  resources { 'mcollective_client_setting': purge => true }
}
