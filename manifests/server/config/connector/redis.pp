#
class mcollective::server::config::connector::redis {
  mcollective::server::setting { 'registerinterval':
    value => 10,
  }

  mcollective::server::setting { 'registration':
    value => 'redis',
  }

  mcollective::plugin { 'registration/redis': }
}
