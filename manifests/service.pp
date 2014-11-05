# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::service
#
# This class is meant to be called from `rundeck`
# It ensure the service is running
#
class rundeck::service(
  $service_name = $rundeck::service_name
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  if $::osfamily == 'Debian' {
      file { '/etc/init.d/rundeckd':
        ensure  => present,
        mode    => '0755',
        content => template('rundeck/init.erb')
      }
  }

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/init.d/rundeckd']
  }
}
