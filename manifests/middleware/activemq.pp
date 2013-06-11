class mcollective::middleware::activemq {
  anchor { 'mcollective::middleware::activemq::begin': } ->
  class { 'mcollective::middleware::activemq::install': } ->
  class { 'mcollective::middleware::activemq::config': } ~>
  class { 'mcollective::middleware::activemq::service': } ->
  anchor { 'mcollective::middleware::activemq::end': }
}
