# Wrap the native type so we have a consistent-looking colon namespaced api
define mcollective::server::setting ($value) {
  mcollective_server_setting { $title:
    value   => $value,
    require => Class['mcollective::server::install'],
    notify  => Class['mcollective::server::service'],
  }
}
