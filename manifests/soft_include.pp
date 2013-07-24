# Define mcollective::soft_include
define mcollective::soft_include($start, $end) {
  if defined($name) {
    class { $name:
      require => $start,
      before  => $end,
    }
  }
}
