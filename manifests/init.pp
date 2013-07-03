# Class - mcollective
class mcollective (
  $connector = 'activemq',
  $server_activemq_user = 'mcollective',
  $server_activemq_password = 'marionette',
  $activemq_hosts = [],
  $factsource = 'yaml',
  $securityprovider = 'ssl',
  $rpcauthprovider = 'action_policy',
  $rpcauditprovider = 'logfile',
  $psk = 'changeme',
  $libdir = $mcollective::defaults::libdir,
  $server_public_pem = "${settings::ssldir}/public_keys/${::fqdn}.pem",
  $server_private_pem = "${settings::ssldir}/private_keys/${::fqdn}.pem",
  $server_daemonize = 1,
  $activemq_console = false, # ubuntu why you no jetty.xml!
  $middleware_ssl = true,
  $server = false,
  $client = false,
  $middleware = false,
) inherits mcollective::defaults {
  anchor { 'mcollective::begin': }
  anchor { 'mcollective::end': }

  if $client {
    Anchor['mcollective::begin'] ->
    class { 'mcollective::client': } ->
    Anchor['mcollective::end']
  }
  if $server {
    Anchor['mcollective::begin'] ->
    class { 'mcollective::server': } ->
    Anchor['mcollective::end']
  }
  if $middleware {
    Anchor['mcollective::begin'] ->
    class { "mcollective::middleware::${connector}": } ->
    Anchor['mcollective::end']
  }
}
