# private class
class mcollective::server::config::connector::rabbitmq {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # Oh puppet!  Fake iteration of the indexes (+1 as plugin.activemq.pool is
  # 1-based)
  $pool_size = size($mcollective::middleware_hosts_real)
  $indexes = range('1', size($mcollective::middleware_hosts_real))
  mcollective::server::config::connector::rabbitmq::hosts_iteration { $indexes: }
}
