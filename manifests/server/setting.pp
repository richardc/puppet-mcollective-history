# Define - mcollective::server::setting
define mcollective::server::setting($value, $order = '10') {
  # One day, puppet will have a real parser.  One day
  $data = {}
  $data[$title] = $value
  datacat_fragment { "mcollective::server::setting ${title}":
    target => [ 'mcollective::server' ],
    order  => $order,
    data   => $data,
  }
}
