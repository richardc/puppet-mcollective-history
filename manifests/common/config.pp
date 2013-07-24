#
class mcollective::common::config {
  file { $mcollective::site_libdir:
    ensure       => directory,
    recurse      => true,
    purge        => true,
    source       => [],
    sourceselect => 'all',
  }

  datacat_collector { 'mcollective::site_libdir':
    before          => File[$mcollective::site_libdir],
    target_resource => File[$mcollective::site_libdir],
    target_field    => 'source',
    source_key      => 'source_path',
  }

  datacat_fragment { 'mcollective::site_libdir':
    target => 'mcollective::site_libdir',
    data   => {
      source_path => [ 'puppet:///modules/mcollective/site_libdir' ],
    }
  }

  mcollective::setting { 'mcollective::common libdir':
    setting => 'libdir',
    target  => [ 'mcollective::server', 'mcollective::client' ],
    value   => "${mcollective::site_libdir}:${mcollective::core_libdir}",
  }

  anchor { 'mcollective::common::config::begin': }
  anchor { 'mcollective::common::config::end': }

  $connector_class = "mcollective::common::config::connector::${mcollective::connector}"
  if defined($connector_class) {
    class { $connector_class:
      require => Anchor['mcollective::common::config::begin'],
      before  => Anchor['mcollective::common::config::end'],
    }
  }
}
