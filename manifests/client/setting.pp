# Define - mcollective::client::setting
define mcollective::client::setting($value) {
  mcollective_client_setting { $title:
    value   => $value,
    require => Class['mcollective::client::install'],
  }
}
