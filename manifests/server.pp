# private class
class mcollective::server {
  anchor { 'mcollective::server::begin': } ->
  class { 'mcollective::server::install': } ->
  class { 'mcollective::server::config': } ~>
  class { 'mcollective::server::service': } ->
  anchor { 'mcollectve::server::end': }
}
