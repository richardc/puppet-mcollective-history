# semi-public class
class mcollective::middleware {
  anchor { 'mcollective::middleware::begin': } ->
  class { "mcollective::middleware::${mcollective::connector}": } ->
  anchor { 'mcollective::middleware::end': }
}
