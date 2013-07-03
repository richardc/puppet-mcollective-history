# private class
class mcollective::middleware::activemq::config {
  if $::osfamily == 'Debian' {
    # Debian-based systems use a instances-available/instances-enabled
    # structure.
    file { $mcollective::activemq_confdir:
      ensure => 'directory',
    }

    # This will log to /var/lib/activemq/mcollective/data/activemq.log
    file { '/etc/activemq/instances-available/mcollective/log4j.properties':
      source => 'puppet:///modules/mcollective/log4j.properties',
    }

    # make available
    file { '/etc/activemq/instances-enabled/mcollective':
      ensure => 'link',
      target => '/etc/activemq/instances-available/mcollective',
    }
  }

  anchor { 'mcollective::middleware::activemq::config::begin': } ->
  file { "${mcollective::activemq_confdir}/activemq.xml":
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
