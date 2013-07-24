#
define mcollective::plugin($source_path = undef) {
  datacat_fragment { "mcollective::plugin ${name}":
    target => 'mcollective::site_libdir',
    data   => {
      source_path => [ $source_path ],
    },
  }
}
