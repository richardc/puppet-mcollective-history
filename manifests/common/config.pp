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
}
