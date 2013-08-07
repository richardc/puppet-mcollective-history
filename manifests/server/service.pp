# private class
class mcollective::server::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $service_name = $mcollective::enterprise ? {
    true    => 'pe-mcollective',
    default => 'mcollective',
  }

  service { 'mcollective':
    ensure => 'running',
    enable => true,
    name   => $service_name,
  }
}
