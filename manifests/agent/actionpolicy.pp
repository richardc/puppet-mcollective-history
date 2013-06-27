# Define - mcollective::agent::actionpolicy
define mcollective::agent::actionpolicy(
  $agent,
  $action   = 'allow',
  $callerid = '*',
  $actions  = '*',
  $facts = '*',
  $classes = '*'
) {
  concat::fragment { "mcollective::agent::actionpolicy ${title}":
    target  => "/etc/mcollective/policies/${agent}.policy",
    content => template('mcollective/actionpolicy_line.erb'),
    order   => '10',
  }
}
