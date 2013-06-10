# Wrap the native type so we have a consistent-looking colon namespaced api
define mcollective::server::setting ($value) {
  mcollective_server_setting { $title:
    value => $value,
  }
}
