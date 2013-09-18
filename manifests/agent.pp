# Define - mcollective agent
# Sets up the actionpolicy for an agent
# Install them with mcollective::plugin
# Namevar will be the name of the agent to configure
define mcollective::agent($policy = 'deny') {
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
