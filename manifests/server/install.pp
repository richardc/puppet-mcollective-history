# private class
class mcollective::server::install {
  package { 'mcollective':
    ensure => 'installed',
  }
}
