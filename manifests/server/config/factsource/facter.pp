# private class
class mcollective::server::config::factsource::facter {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  package { 'mcollective-facter-facts':
    ensure => installed,
  }

  mcollective::server::setting { 'factsource':
    value => 'facter',
  }

  mcollective::server::setting { 'fact_cache_time':
    value => 300,
  }
}
