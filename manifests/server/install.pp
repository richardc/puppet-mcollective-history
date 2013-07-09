# private class
class mcollective::server::install {
  package { 'mcollective':
    ensure => 'installed',
  }

  if $::osfamily == 'Debian' {
    # XXX you be shitting me
    package { 'ruby-stomp':
      ensure => 'installed',
      before => Package['mcollective'],
    }
  }
}
