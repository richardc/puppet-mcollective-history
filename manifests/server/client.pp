# Define - mcollective::::server::client
define mcollective::server::client($certificate) {
  file { "/etc/mcollective/clients/${name}.pem":
    source => $certificate,
    owner  => $name,
    mode   => '0444',
  }
}
