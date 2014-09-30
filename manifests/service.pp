# == Class rundeck::service
#
# This class is meant to be called from rundeck
# It ensure the service is running
#
class rundeck::service(
  $service_name = $rundeck::service_name
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
