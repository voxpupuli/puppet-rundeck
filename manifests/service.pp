# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::service
#
# This class is meant to be called from `rundeck`
# It ensures the service is running
#
class rundeck::service (
  $service_config = $rundeck::service_config,
  $service_name   = $rundeck::service_name,
  $service_script = $rundeck::service_script,
) {

  assert_private()

  File {
    ensure => file,
    notify => Service['rundeckd'],
  }

  #file { '/etc/init/rundeckd.conf':
  #  mode    => '0644',
  #  content => template($service_config),
  #}
  #
  #file { '/etc/init.d/rundeckd':
  #  mode    => '0755',
  #  content => template($service_script),
  #}

  service { 'rundeckd':
    ensure     => running,
    name       => $service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
