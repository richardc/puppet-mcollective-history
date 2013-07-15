# Define - mcollective::client::setting
define mcollective::client::setting($value, $order = '30') {
  mcollective::setting { "mcollective::client::setting ${title}":
    setting => $title,
    value   => $value,
    target  => [ 'mcollective::client', 'mcollective::user' ],
    order   => $order,
  }
}
