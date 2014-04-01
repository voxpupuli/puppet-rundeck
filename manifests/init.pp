# == Class: rundeck
#
# This will install rundeck (http://rundeck.org/) and manage it's configration and plugins
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*package_version*]
# The version of rundeck to be installed
#
# [*jre_name*]
# The name of the jre to be installed if using a custom jre.
#
# [*jre_version*]
# The version of the jre to be installed if using a custom jre.
#
# === Examples
#
# Installing rundeck with a custom jre:
#
# class { 'rundeck':
#   jre_name    => 'openjdk-7-jre',
#   jre_version => '7u51-2.4.4-0ubuntu0.12.04.2'
# }
#
class rundeck (
  $package_version = $rundeck::params::package_version,
  $jre_name = $rundeck::params::jre_name,
  $jre_version = $rundeck::params::jre_version,
  $auth_type = $rundeck::params::auth_type,
  $users = $rundeck::params::file_users
) inherits rundeck::params {

  #TODO: add all options from params.pp

  validate_string($package_version)
  validate_string($jre_name)
  validate_string($jre_version)

  class { 'rundeck::install': } ->
  class { 'rundeck::config': } ~>
  class { 'rundeck::service': } ->
  Class['rundeck']
}
