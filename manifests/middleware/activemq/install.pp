# private class
class mcollective::middleware::activemq::install {
  package { 'activemq':
    ensure => 'installed',
  }
}
