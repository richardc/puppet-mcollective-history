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
  $ssl_ca_cert = "${settings::ssldir}/certs/ca.pem",
  $ssl_server_public = "${settings::ssldir}/certs/${::fqdn}.pem",
  $ssl_server_private = "${settings::ssldir}/private_keys/${::fqdn}.pem",
  $ssl_client_certs = 'puppet:///modules/mcollective/empty',
  $server_daemonize = 1,
  $activemq_confdir = $mcollective::defaults::activemq_confdir,
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
    class { 'mcollective::middleware': } ->
    Anchor['mcollective::end']
  }
}
