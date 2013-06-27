# Define - mcollective agent
# Namevar will be the name of the agent to install
define mcollective::agent($policy = 'deny') {
  package { "mcollective-${name}-agent":
    ensure => 'installed',
  }

  concat { "/etc/mcollective/policies/${name}.policy":
  }

  concat::fragment { "mcollective::agent ${name} policy default":
    order   => '00',
    target  => "/etc/mcollective/policies/${name}.policy",
    content => "policy default ${policy}\n",
  }
}
