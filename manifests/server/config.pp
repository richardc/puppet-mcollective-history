# Class - mcollective::server::config
class mcollective::server::config {
  mcollective::server::setting { 'libdir':
    value => $mcollective::libdir,
  }
}
