# private class
class mcollective::middleware::activemq::config::keystore {
  java_ks { 'mcollective:truststore':
    ensure       => 'latest',
    certificate  => '/var/lib/puppet/ssl/certs/ca.pem',
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
    certificate  => "${::settings::ssldir}/certs/${::clientcert}.pem",
    private_key  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
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
