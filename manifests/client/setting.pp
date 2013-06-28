# Define - mcollective::client::setting
define mcollective::client::setting($value) {
  mcollective_client_setting { $title:
    value   => $value,
    require => Anchor['mcollective::client::config::begin'],
    before  => Anchor['mcollective::client::config::end'],
  }
}
