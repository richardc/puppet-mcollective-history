class mcollective::activemq {
  anchor { 'mcollective::activemq::begin': } ->
  class { 'mcollective::activemq::install': } ->
  class { 'mcollective::activemq::config': } ~>
  class { 'mcollective::activemq::service': }
  anchor { 'mcollective::activemq::end': }
}
