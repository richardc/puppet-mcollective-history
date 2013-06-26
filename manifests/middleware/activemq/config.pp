# private class
class mcollective::middleware::activemq::config {
  file { '/etc/activemq/activemq.xml':
    content => template("${module_name}/activemq.xml.erb"),
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0600',
  }
}
