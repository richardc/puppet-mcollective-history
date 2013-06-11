# Class - mcolllective::server::install
class mcollective::server::install {
  package { 'mcollective':
    ensure => 'installed',
  }
}
