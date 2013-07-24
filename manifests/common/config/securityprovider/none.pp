# Private class
class mcollective::common::config::securityprovider::none {
  mcollective::plugin { 'securityprovider/none':
    source_path => 'puppet:///modules/mcollective/plugins/securityprovider/none',
  }
}
