class test1 {
  class { 'mcollective': }
  class { 'mcollective::server': }
  mcollective::server::setting { 'connector':
    value => 'activemq',
  }
}
