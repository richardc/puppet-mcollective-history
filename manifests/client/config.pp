# Class - mcollective::client::config
class mcollective::client::config {
  mcollective::client::setting { 'libdir':
    value => $mcollective::libdir,
  }
}
