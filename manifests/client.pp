# Installs the client and sets up /etc/mcollective/client.cfg (global/common
# configuration)
class mcollective::client {
  # delete any non-managed keys
  resources { 'mcollective_client_setting': purge => true }
  anchor { 'mcollective::client::begin': } ->
  class { 'mcollective::client::install': } ->
  class { 'mcollective::client::config': } ->
  anchor { 'mcollective::client::end': }
}
