#
class site_mcollective::server {
  class { '::mcollective::server': }

  mcollective::agent { 'rpcutil':
    policy => 'deny',
  }

  mcollective::agent::actionpolicy { 'root rpcutil':
    agent    => 'rpcutil',
    callerid => 'cert=root',
  }
}
