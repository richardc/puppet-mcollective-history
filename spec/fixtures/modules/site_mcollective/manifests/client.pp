#
class site_mcollective::client {
  mcollective::user { 'root':
    homedir     => '/root',
    certificate => "puppet:///modules/${module_name}/certs/root.pem",
    private_key => "puppet:///modules/${module_name}/private_keys/root.pem",
  }
}
