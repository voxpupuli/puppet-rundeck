# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::service
#
# This class is meant to be called from `rundeck`
# It ensure the service is running
#
class rundeck::service(
  $service_name = $rundeck::service_name,
  $service_manage = $rundeck::service_manage,
  $service_script = $rundeck::service_script,
  $service_config = $rundeck::service_config
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $service_manage {
    file { '/etc/init/rundeckd.conf':
      ensure  => present,
      mode    => '0644',
      content => template($service_config)
    }

    file { '/etc/init.d/rundeckd':
      ensure  => present,
      mode    => '0755',
      content => template($service_script)
    }
  }

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
