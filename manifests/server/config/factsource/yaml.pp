# private class
class mcollective::server::config::factsource::yaml {
  # The facts.yaml file resource is generated in its own dedicated class
  # By doing this, the file produced isn't polluted with unwanted in scope
  # class variables.
  # Also we're not in the config class as we don't need to restart the service
  # when the facts just change.

  file { '/etc/mcollective/facts.yaml':
    owner   => root,
    group   => root,
    mode    => '0400',
    content => template('mcollective/facts.yaml.erb'),
  }

  mcollective::server::setting { 'factsource':
    value => 'yaml',
  }

  mcollective::server::setting { 'plugin.yaml':
    value => '/etc/mcollective/facts.yaml',
  }
}
