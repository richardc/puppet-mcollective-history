# Class - mcollective
class mcollective (
  $version = 'present',
  $enterprise = false,
  $manage_packages = true,
  $connector = 'activemq',
  $server_activemq_user = 'mcollective',
  $server_activemq_password = 'marionette',
  $factsource = 'yaml',
  $securityprovider = 'ssl',
  $rpcauthprovider = 'action_policy',
  $rpcauditprovider = 'logfile',
  $registration = undef,
  $psk = 'changeme',
  $core_libdir = $mcollective::defaults::core_libdir,
  $site_libdir = $mcollective::defaults::site_libdir,
  $ssl_ca_cert = "${settings::ssldir}/certs/ca.pem",
  $ssl_server_public = "${settings::ssldir}/certs/${::fqdn}.pem",
  $ssl_server_private = "${settings::ssldir}/private_keys/${::fqdn}.pem",
  $ssl_client_certs = 'puppet:///modules/mcollective/empty',
  $server_logfile   = '/var/log/mcollective.log',
  $server_loglevel  = 'info',
  $server_daemonize = 1,
  $activemq_confdir = $mcollective::defaults::activemq_confdir,
  $activemq_console = false, # ubuntu why you no jetty.xml!
  $middleware_hosts = [],
  $middleware_ssl = true,
  $server = true,
  $server_config = undef,
  $server_config_file = '/etc/mcollective/server.cfg',
  $client = false,
  $middleware = false,
) inherits mcollective::defaults {
  anchor { 'mcollective::begin': }
  anchor { 'mcollective::end': }


  if $client or $server {
    # We don't want this on middleware roles.
    Anchor['mcollective::begin'] ->
    class { '::mcollective::common': } ->
    Anchor['mcollective::end']
  }
  if $client {
    Anchor['mcollective::begin'] ->
    class { '::mcollective::client': } ->
    Anchor['mcollective::end']
  }
  if $server {
    Anchor['mcollective::begin'] ->
    class { '::mcollective::server': } ->
    Anchor['mcollective::end']
  }
  if $middleware {
    Anchor['mcollective::begin'] ->
    class { '::mcollective::middleware': } ->
    Anchor['mcollective::end']
  }
}
