# Class - mcollective::server::service
class mcollective::server::service {
  service { 'mcollective':
    ensure => 'running',
    enable => true,
  }
}
