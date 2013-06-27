# Define - mcollective::::server::client
define mcollective::server::client(
  $cert_public,
  $cert_private
) {
  file { "/etc/mcollective/clients/${name}-public.pem":
    source => $cert_public,
    owner  => $name,
    mode   => '0444',
  }

  file { "/etc/mcollective/clients/${name}-private.pem":
    source => $cert_private,
    owner  => $name,
    mode   => '0400',
  }
}
