# Define - mcollective::server::setting
define mcollective::server::setting($value) {
  # One day, puppet will have a real parser.  One day
  $data = {}
  $data[$title] = $value
  datacat_fragment { "mcollective::server::setting ${title}":
    target => [ 'mcollective::server' ],
    order  => '60',
    data   => $data,
  }
}
