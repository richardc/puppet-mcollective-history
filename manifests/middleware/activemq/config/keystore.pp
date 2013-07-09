# private class
class mcollective::middleware::activemq::config::keystore {
  java_ks { 'mcollective:truststore':
    ensure       => 'latest',
    certificate  => '/etc/mcollective/ca.pem',
    target       => "${mcollective::activemq_confdir}/truststore.jks",
    password     => 'puppet',
    trustcacerts => true,
  } ->

  file { "${mcollective::activemq_confdir}/truststore.jks":
    owner => 'activemq',
    group => 'activemq',
    mode  => '0600',
  }

  java_ks { 'mcollective:keystore':
    ensure       => 'latest',
    certificate  => '/etc/mcollective/server_public.pem',
    private_key  => '/etc/mcollective/server_private.pem',
    target       => "${mcollective::activemq_confdir}/keystore.jks",
    password     => 'puppet',
    trustcacerts => true,
  } ->

  file { "${mcollective::activemq_confdir}/keystore.jks":
    owner => 'activemq',
    group => 'activemq',
    mode  => '0600',
  }
}
