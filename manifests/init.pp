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
  $server = false,
  $client = false,
  $middleware = false,
) inherits mcollective::defaults {
  if $client {
    class { 'mcollective::client': }
  }
  if $server {
    class { 'mcollective::server': }
  }
  if $middleware {
    class { "mcollective::middleware::${connector}": }
  }
}
