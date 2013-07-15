# Define - mcollective agent
# Namevar will be the name of the agent to install
define mcollective::agent(
  $policy = 'deny',
  $package = false,
  $package_name = undef,
)
{
  if $package {
    if $package_name {
      $real_package_name = $package_name
    }
    else {
      $real_package_name = "mcollective-${name}-agent"
    }

    package { $real_package_name:
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
