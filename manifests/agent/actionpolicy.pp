# Define - mcollective::agent::actionpolicy
define mcollective::agent::actionpolicy(
  $agent,
  $action   = 'allow',
  $callerid = '*',
  $actions  = '*',
  $facts = '*',
  $classes = '*'
) {
  datacat_fragment { "mcollective::agent::actionpolicy ${title}":
    target => "mcollective::agent ${agent} actionpolicy",
    data   => {
      lines => [
        {
          'action'   => $action,
          'callerid' => $callerid,
          'actions'  => $actions,
          'facts'    => $facts,
          'classes'  => $classes,
        },
      ],
    },
  }
}
