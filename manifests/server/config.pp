# Class - mcollective::server::config
class mcollective::server::config {
  mcollective::server::setting { 'libdir':
    value => $mcollective::libdir,
  }

  mcollective::server::setting { 'daemonize':
    value => $mcollective::server_daemonize,
  }
}
