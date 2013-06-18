# Class - mcollective
class mcollective (
  $connector = 'activemq',
  $server_activemq_user = 'mcollective',
  $server_activemq_password = 'marionette',
  $activemq_hosts = [],
  $factsource = 'yaml',
  $securityprovider = 'psk',
  $psk = 'changeme',
  $libdir = $mcollective::defaults::libdir,
  $server_daemonize = 1,
) inherits mcollective::defaults {
}
