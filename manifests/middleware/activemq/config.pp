# private class
class mcollective::middleware::activemq::config {
  anchor { 'mcollective::middleware::activemq::config::begin': } ->
  file { '/etc/activemq/activemq.xml':
    content => template("${module_name}/activemq.xml.erb"),
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0600',
  } ->
  anchor { 'mcollective::middleware::activemq::config::end': }

  if $mcollective::middleware_ssl {
    class { 'mcollective::middleware::activemq::config::keystore':
      require => Anchor['mcollective::middleware::activemq::config::begin'],
      before  => Anchor['mcollective::middleware::activemq::config::end'],
      notify  => Class['mcollective::middleware::activemq::service'],
    }
  }

}
