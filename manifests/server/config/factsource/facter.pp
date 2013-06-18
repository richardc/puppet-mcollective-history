# Class - mcollective::server::config::factsource::facter
class mcollective::server::config::factsource::facter {
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
