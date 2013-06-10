# Define - mcollective::client::setting
define mcollective::client::setting($value) {
  mcollective_client_setting { $title:
    value => $value,
  }
}
