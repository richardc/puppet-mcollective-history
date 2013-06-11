class mcollective::client::install {
  package { 'mcollective-client':
    ensure => 'installed',
  }
}
