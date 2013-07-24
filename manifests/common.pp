#
class mcollective::common {
  anchor { 'mcollective::common::begin': } ->
  class { 'mcollective::common::config': } ->
  anchor { 'mcollective::common::end': }
}
