# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::service
#
# This class is meant to be called from `rundeck`
# It ensure the service is running
#
class rundeck::service {
  assert_private()

  $service_config = $rundeck::service_config
  $service_name   = $rundeck::service_name
  $service_script = $rundeck::service_script
  $service_ensure = $rundeck::service_ensure

  if $service_config {
    file { '/etc/init/rundeckd.conf':
      ensure  => file,
      mode    => '0644',
      content => template($service_config),
    }
  }

  if $service_script {
    file { '/etc/init.d/rundeckd':
      ensure  => file,
      mode    => '0755',
      content => template($service_script),
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
