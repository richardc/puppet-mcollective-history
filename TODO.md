
= Undocumented

    $version = 'present',
    $enterprise = false,
    $manage_packages = true,
    $main_collective = 'mcollective',
    $collectives = 'mcollective',
    $classesfile = '/var/lib/puppet/state/classes.txt',
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
    $middleware_vhost = '/mcollective', # used by rabbitmq
    $server_config_file = '/etc/mcollective/server.cfg',
    $client_config_file = '/etc/mcollecti

= Untested

    $rabbitmq_confdir = '/etc/rabbitmq',
    $middleware_vhost = '/mcollective', # used by rabbitmq
