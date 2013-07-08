# Define - mcollective::user::setting
define mcollective::user::setting($username, $value, $order = '60') {
  $setting = regsubst($title, "^${username}[ _:]", '')
  $data = {}
  $data[$setting] = $value
  datacat_fragment { "mcollective::user ${username} ${setting}":
    target => "mcollective::user ${username}",
    data   => $data,
    order  => $order,
  }
}
