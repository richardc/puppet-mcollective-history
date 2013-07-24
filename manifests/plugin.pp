#
define mcollective::plugin($source = "puppet:///modules/mcollective/plugins/${name}") {
  datacat_fragment { "mcollective::plugin ${name}":
    target => 'mcollective::site_libdir',
    data   => {
      source_path => [ $source ],
    },
  }
}
