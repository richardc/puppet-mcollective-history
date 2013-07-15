# Define - mcollective::server::setting
define mcollective::server::setting($value, $order = '10') {
  mcollective::setting { "mcollective::server::setting ${title}":
    setting => $title,
    value   => $value,
    target  => [ 'mcollective::server' ],
    order   => $order,
  }
}
