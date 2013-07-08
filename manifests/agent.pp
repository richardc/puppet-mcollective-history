# Define - mcollective agent
# Namevar will be the name of the agent to install
define mcollective::agent(
  $policy = 'deny',
  $package = false
)
{
  if $package {
    package { "mcollective-${name}-agent":
      ensure => 'installed',
    }
  }

  datacat { "mcollective::agent ${name} actionpolicy":
    path     => "/etc/mcollective/policies/${name}.policy",
    template => 'mcollective/actionpolicy.erb',
  }

  datacat_fragment { "mcollective::agent ${name} actionpolicy default":
    target => "mcollective::agent ${name} actionpolicy",
    data   => {
      'default' => $policy,
    },
  }
}
