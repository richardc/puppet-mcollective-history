class mcollective::activemq::service {
  service { 'activemq':
    ensure => 'running',
    enable => true,
  }
}
