# semi-public class
class mcollective::middleware {
  anchor { 'mcollective::middleware::begin': }
  anchor { 'mcollective::middleware::end': }

  mcollective::soft_include { "::mcollective::middleware::${mcollective::connector}":
    start => Anchor['mcollective::middleware::begin'],
    end   => Anchor['mcollective::middleware::end'],
  }
}
