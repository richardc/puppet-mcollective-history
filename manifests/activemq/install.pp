class mcollective::activemq::install {
  package { 'activemq':
    ensure => 'installed',
  }
}
