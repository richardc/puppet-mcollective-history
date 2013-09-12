# Class - mcollective
class mcollective (
  $version = 'present',
  $enterprise = false,
  $manage_packages = true,
  $connector = 'activemq',
  $main_collective = 'mcollective',
  $collectives = 'mcollective',
  $classesfile = '/var/lib/puppet/state/classes.txt',
  $factsource = 'yaml',
  $fact_source = 'UNSET',
  $yaml_fact_path = '/etc/mcollective/facts.yaml',
  $yaml_facter_source = 'UNSET',
  $mc_security_provider = 'UNSET',
  $mc_security_psk = 'UNSET',
  $securityprovider = 'ssl',
  $rpcauthprovider = 'action_policy',
  $rpcauditprovider = 'logfile',
  $registration = undef,
  $psk = 'changemeplease',
  $core_libdir = $mcollective::defaults::core_libdir,
  $site_libdir = $mcollective::defaults::site_libdir,
  # stomp_* parameters are from the old module, deprecated
  $stomp_pool = 'UNSET',
  $stomp_server = 'UNSET',
  $stomp_user = 'UNSET',
  $stomp_passwd = 'UNSET',
  $plugin_params = 'UNSET',
  $ssl_ca_cert = "${settings::ssldir}/certs/ca.pem",
  $ssl_server_public = "${settings::ssldir}/certs/${::fqdn}.pem",
  $ssl_server_private = "${settings::ssldir}/private_keys/${::fqdn}.pem",
  $ssl_client_certs = 'puppet:///modules/mcollective/empty',
  $server_logfile   = '/var/log/mcollective.log',
  $server_loglevel  = 'info',
  $server_daemonize = 1,
  $activemq_template = 'mcollective/activemq.xml.erb',
  $activemq_config = undef,
  $activemq_confdir = $mcollective::defaults::activemq_confdir,
  $activemq_console = false, # ubuntu why you no jetty.xml!
  $middleware_hosts = [],
  $middleware_user = 'mcollective',
  $middleware_password = 'marionette',
  $middleware_ssl = true,
  $middleware_port = '61614',
  $middleware_vhost = '/mcollective', # used by rabbitmq
  $server = true,
  $server_config = undef,
  $server_config_file = '/etc/mcollective/server.cfg',
  $client = false,
  $client_config = undef,
  $client_config_file = '/etc/mcollective/client.cfg',
  $middleware = false,
) inherits mcollective::defaults {
  anchor { 'mcollective::begin': }
  anchor { 'mcollective::end': }

  if $plugin_params != 'UNSET' {
    # We don't really have a sane way to unpack/remap this one as it's a wierd
    # data structure with irregular keys for configuration.
    fail('Use of deprecated parameter `plugin_params`.  Use `mcollective::server::setting` resources in preference.')
  }

  if $stomp_pool != 'UNSET' {
    # We don't really have a sane way to unpack/remap this one as it's a wierd
    # data structure with irregular keys for configuration.
    fail('Use of deprecated parameter `stomp_hosts`.  Use `middleware_hosts`, `middleware_user`, and `middleware_password` instead.')
  }

  if $stomp_server != 'UNSET' {
    notice('Use of deprecated parameter `stomp_server`. Use `middleware_hosts` instead.')
    $middleware_hosts_real = [ $stomp_server ]
  }
  else {
    $middleware_hosts_real = $middleware_hosts
  }

  if $stomp_user != 'UNSET' {
    notice('Use of deprecated parameter `stomp_user`. Use `middleware_user` instead.')
    $middleware_user_real = $stomp_user
  }
  else {
    $middleware_user_real = $middleware_user
  }

  if $stomp_passwd != 'UNSET' {
    notice('Use of deprecated parameter `stomp_passwd`. Use `middleware_password` instead.')
    $middleware_password_real = $stomp_passwd
  }
  else {
    $middleware_password_real = $middleware_password
  }

  if $mc_security_provider != 'UNSET' {
    notice('Use of deprecated parameter `mc_security_provider`.  Use `securityprovider` instead.')
    $securityprovider_real = $mc_security_provider
  }
  else {
    $securityprovider_real = $securityprovider
  }

  if $mc_security_psk != 'UNSET' {
    notice('Use of deprecated parameter `mc_security_psk`.  Use `psk` instead.')
    $psk_real = $mc_security_psk
  }
  else {
    $psk_real = $psk
  }

  if $fact_source != 'UNSET' {
    notice('Use of deprecated parameter `fact_source`. Use `factsource` instead.')
    $factsource_real = $fact_source
  }
  else {
    $factsource_real = $factsource
  }

  if $yaml_facter_source != 'UNSET' {
    notice('Use of deprecated parameter `yaml_facter_source`. Use `yaml_fact_path` instead')
    $yaml_fact_path_real = $yaml_facter_source
  }
  else {
    $yaml_fact_path_real = $yaml_fact_path
  }

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
