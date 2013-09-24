# Class - mcollective
class mcollective (
  $version = 'present',
  $manage_packages = true,
  $connector = 'activemq',
  $main_collective = 'mcollective',
  $collectives = 'mcollective',
  $classesfile = '/var/lib/puppet/state/classes.txt',
  $factsource = 'yaml',
  $yaml_fact_path = '/etc/mcollective/facts.yaml',
  $securityprovider = 'psk',
  $rpcauthprovider = 'action_policy',
  $rpcauditprovider = 'logfile',
  $registration = undef,
  $psk = 'changemeplease',
  $core_libdir = $mcollective::defaults::core_libdir,
  $site_libdir = $mcollective::defaults::site_libdir,
  $ssl_ca_cert = undef,
  $ssl_server_public = undef,
  $ssl_server_private = undef,
  $ssl_client_certs = 'puppet:///modules/mcollective/empty',
  $server_logfile   = '/var/log/mcollective.log',
  $server_loglevel  = 'info',
  $client_logger_type = 'console',
  $client_loglevel = 'warn',
  $server_daemonize = 1,
  $activemq_template = 'mcollective/activemq.xml.erb',
  $activemq_config = undef,
  $activemq_confdir = $mcollective::defaults::activemq_confdir,
  $activemq_console = false, # ubuntu why you no jetty.xml!
  $rabbitmq_confdir = '/etc/rabbitmq',
  $middleware_hosts = [],
  $middleware_user = 'mcollective',
  $middleware_password = 'marionette',
  $middleware_ssl = false,
  $middleware_port = '61613',
  $middleware_ssl_port = '61614',
  $rabbitmq_vhost = '/mcollective', # used by rabbitmq
  $server = true,
  $server_config_file = '/etc/mcollective/server.cfg',
  $client = false,
  $client_config_file = '/etc/mcollective/client.cfg',
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
