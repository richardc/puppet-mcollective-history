# private class
# Installs the client and sets up /etc/mcollective/client.cfg (global/common
# configuration)
class mcollective::client {
  anchor { 'mcollective::client::begin': } ->
  class { 'mcollective::client::install': } ->
  class { 'mcollective::client::config': } ->
  anchor { 'mcollective::client::end': }
}
