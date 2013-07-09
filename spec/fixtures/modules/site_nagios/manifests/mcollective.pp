# This would be the module you put on all your nrpe-monitored nodes
class site_nagios::mcollective {
  # fake install nrpe
  file { ['/etc/nagios', '/etc/nagios/nrpe.d']:
      ensure => 'directory',
  }

  file { '/etc/nagios/nrpe.d/hello_world.cfg':
      content => "command[hello_world]=echo Hello World!\n",
  }

  mcollective::agent { 'nrpe':
    policy  => 'deny',
    package => true,
  }

  mcollective::agent::actionpolicy { 'root nrpe':
    agent    => 'nrpe',
    callerid => 'cert=root',
  }

  mcollective::agent::actionpolicy { 'nagios nrpe':
    agent    => 'nrpe',
    callerid => 'cert=nagios',
    actions  => 'runcommand',
  }
}
