class mcollective (
  $connector = 'activemq',
  $server_activemq_user = 'mcollective',
  $server_activemq_password = 'marionette',
  $activemq_hosts = [],
  $securityprovider = 'psk',
  $psk = 'changeme',
  $libdir = $mcollective::defaults::libdir,
  $server_daemonize = 1,
) inherits mcollective::defaults {
}
