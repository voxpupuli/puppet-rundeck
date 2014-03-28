# == Class rundeck::params
#
# This class is meant to be called from rundeck
# It sets variables according to platform
#
class rundeck::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'rundeck'
      $package_version = '2.0.3-1-GA'
      $service_name = 'rundeckd'
      $jre_name = 'openjdk-6-jre'
      $jre_version = '6b30-1.13.1-1ubuntu2~0.12.04.1'
    }
    'RedHat', 'Amazon': {
      $package_name = 'rundeck'
      $package_version = '2.0.3-1.14.GA'
      $service_name = 'rundeckd'
      $jre_name = 'java-1.6.0-openjdk'
      $jre_version = '1.6.0.0-1.66.1.13.0.el6'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }






}
