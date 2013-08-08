# private class
class mcollective::server::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mcollective::manage_packages {
    package { 'mcollective':
      ensure => $mcollective::version,
    }

    if $::osfamily == 'Debian' {
      # XXX you be shitting me
      package { 'ruby-stomp':
        ensure => 'installed',
        before => Package['mcollective'],
      }
    }
  }
}
