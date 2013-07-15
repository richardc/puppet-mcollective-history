# Define - mcollective::user::setting
define mcollective::user::setting($username, $value, $order = '70') {
  $setting = regsubst($title, "^${username}[ _:]", '')
  mcollective::setting { "mcollective::user::setting ${title}":
    setting => $setting,
    value   => $value,
    target  => "mcollective::user ${username}",
    order   => $order,
  }
}
