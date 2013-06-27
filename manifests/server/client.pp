# Define - mcollective::::server::client
define mcollective::server::client($cert_public) {
  file { "/etc/mcollective/clients/${name}.pem":
    source => $cert_public,
    owner  => $name,
    mode   => '0444',
  }
}
