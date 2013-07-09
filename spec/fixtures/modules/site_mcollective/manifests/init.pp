#
class site_mcollective {
  class { 'mcollective':
    activemq_hosts     => [ 'localhost' ],
    ssl_client_certs   => "puppet:///modules/${module_name}/certs",
    ssl_ca_cert        => "puppet:///modules/${module_name}/certs/ca.pem",
    ssl_server_public  => "puppet:///modules/${module_name}/certs/server.pem",
    ssl_server_private => "puppet:///modules/${module_name}/private_keys/server.pem",
  }
}
