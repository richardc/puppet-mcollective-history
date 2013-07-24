# installs an mcollective connector from a package or module
define mcollective::connector(
  $package = false,
  $package_name = "mcollective-connector-${name}",
  $module = undef,
) {
  if $package {
    package { $package_name:
      ensure => installed,
    }
  }

  if $module {
    file { "${mcollective::site_libdir}/mcollective/connector/${name}.rb":
      source => "puppet:///modules/${module}/lib/mcollective/connector/${name}.rb",
    }
  }
}
