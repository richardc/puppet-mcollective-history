# private class
class mcollective::middleware::activemq::config {
  if $::osfamily == 'Debian' {
    # no, rilly
    file { '/etc/activemq/instances-available/mcollective':
      ensure => 'directory',
    }
    # shouldn't rely on this being there to copy
    file { '/etc/activemq/instances-available/mcollective/log4j.properties':
      source => '/etc/activemq/instances-available/main/log4j.properties',
    }

    file { '/etc/activemq/instances-available/mcollective/options':
      source => 'puppet:///modules/mcollective/activemq.ubuntu.options',
    }

    # make available
    file { '/etc/activemq/instances-enabled/mcollective':
      ensure => 'link',
      target => '/etc/activemq/instances-available/mcollective',
    }

    $activemq_conf = '/etc/activemq/instances-available/mcollective/activemq.xml'
  }
  else {
    $activemq_conf = '/etc/activemq/activemq.xml'
  }

  anchor { 'mcollective::middleware::activemq::config::begin': } ->
  file { $activemq_conf:
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
