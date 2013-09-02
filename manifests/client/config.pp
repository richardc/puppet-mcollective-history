# private class
class mcollective::client::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mcollective::client_config {
    file { 'mcollective::client':
      path    => $mcollective::client_config_file,
      content => $mcollective::client_config,
    }
  }
  else {
    datacat { 'mcollective::client':
      path     => $mcollective::client_config_file,
      template => 'mcollective/settings.cfg.erb',
    }
  }

  mcollective::client::setting { 'loglevel':
    value => 'warn',
  }

  mcollective::client::setting { 'logger_type':
    value => 'console',
  }

  mcollective::soft_include { [
    "::mcollective::client::config::connector::${mcollective::connector}",
    "::mcollective::client::config::securityprovider::${mcollective::securityprovider_real}",
  ]:
    start => Anchor['mcollective::client::config::begin'],
    end   => Anchor['mcollective::client::config::end'],
  }

  anchor { 'mcollective::client::config::begin': }
  anchor { 'mcollective::client::config::end': }
}
