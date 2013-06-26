# private class
class mcollective::middleware::activemq::service {
  service { 'activemq':
    ensure => 'running',
    enable => true,
  }
}
