# == Class rundeck::service
#
# This class is meant to be called from rundeck
# It ensure the service is running
#
class rundeck::service {

  service { $rundeck::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
