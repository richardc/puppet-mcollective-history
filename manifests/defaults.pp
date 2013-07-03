# private class
# This class is for setting the few platform defaults that need branching; all
# other configuration should be defaulted using the class paramaters to the
# mcollective class.
# Never refer to $mcollective::defaults::foo values outside of a parameter
# list, it's leak and prevents users from actually having control.
class mcollective::defaults {
  $libdir = $::osfamily ? {
    'Debian' => '/usr/share/mcollective/plugins',
    default  => '/usr/libexec/mcollective',
  }

  $activemq_confdir = $::osfamily ? {
    'Debian' => '/etc/activemq/instances-available/mcollective',
    default  => '/etc/activemq',
  }
}
