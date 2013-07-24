# Define - mcollective::common::setting
define mcollective::common::setting($value) {
  mcollective::setting { "mcollective::common ${name}":
    setting => $name,
    value   => $value,
    target  => [ 'mcollective::server', 'mcollective::client' ],
  }
}
