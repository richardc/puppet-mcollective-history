# private class
class mcollective::middleware::activemq::config::keystore {
  file { "${mcollective::activemq_confdir}/ca.pem":
    source => $mcollective::ssl_ca_cert,
  } ->
  java_ks { 'mcollective:truststore':
    ensure       => 'latest',
    certificate  => "${mcollective::activemq_confdir}/ca.pem",
    target       => "${mcollective::activemq_confdir}/truststore.jks",
    password     => 'puppet',
    trustcacerts => true,
  } ->
  file { "${mcollective::activemq_confdir}/truststore.jks":
    owner => 'activemq',
    group => 'activemq',
    mode  => '0400',
  }

  file { "${mcollective::activemq_confdir}/server_public.pem":
    source => $mcollective::ssl_server_public,
  } ->
  file { "${mcollective::activemq_confdir}/server_private.pem":
    source => $mcollective::ssl_server_private,
  } ->
  java_ks { 'mcollective:keystore':
    ensure       => 'latest',
    certificate  => "${mcollective::activemq_confdir}/server_public.pem",
    private_key  => "${mcollective::activemq_confdir}/server_private.pem",
    target       => "${mcollective::activemq_confdir}/keystore.jks",
    password     => 'puppet',
    trustcacerts => true,
  } ->
  file { "${mcollective::activemq_confdir}/keystore.jks":
    owner => 'activemq',
    group => 'activemq',
    mode  => '0400',
  }
}
