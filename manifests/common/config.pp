#
class mcollective::common::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { $mcollective::site_libdir:
    ensure       => directory,
    recurse      => true,
    purge        => true,
    force        => true,
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

  mcollective::common::setting { 'libdir':
    value => "${mcollective::site_libdir}:${mcollective::core_libdir}",
  }

  mcollective::common::setting { 'connector':
    value => $mcollective::connector,
  }

  mcollective::common::setting { 'securityprovider':
    value => $mcollective::securityprovider_real,
  }

  mcollective::common::setting { 'collectives':
    value => $mcollective::collectives,
  }

  mcollective::common::setting { 'main_collective':
    value => $mcollective::main_collective,
  }

  mcollective::soft_include { [
    "::mcollective::common::config::connector::${mcollective::connector}",
    "::mcollective::common::config::securityprovider::${mcollective::securityprovider_real}",
  ]:
    start => Anchor['mcollective::common::config::begin'],
    end   => Anchor['mcollective::common::config::end'],
  }

  anchor { 'mcollective::common::config::begin': }
  anchor { 'mcollective::common::config::end': }
}
