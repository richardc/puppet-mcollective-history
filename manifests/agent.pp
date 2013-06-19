# Define - mcollective agent
# Namevar will be the name of the agent to install
define mcollective::agent($policy) {
  package { "mcollective-${name}-agent":
    ensure => 'installed',
  }

  file { "/etc/mcollective/policies/${name}.policy":
    ensure  => 'file',
    content => $policy,
  }
}
