# Define - mcollective::common::setting
define mcollective::common::setting($value, $order = '50') {
  mcollective::setting { "mcollective::common::setting ${name}":
    setting => $name,
    value   => $value,
    target  => [ 'mcollective::server', 'mcollective::client' ],
    order   => '50',
  }
}
