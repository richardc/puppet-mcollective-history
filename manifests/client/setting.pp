# Define - mcollective::client::setting
define mcollective::client::setting($value) {
  # One day, puppet will have a real parser.  One day
  $data = {}
  $data[$title] = $value
  datacat_fragment { "mcollective::client::setting ${title}":
    target => [ 'mcollective::client', 'mcollective::user' ],
    order  => '60',
    data   => $data,
  }
}
