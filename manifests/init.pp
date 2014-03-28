# == Class: rundeck
#
# Full description of class rundeck here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class rundeck (
  $package_version = $rundeck::params::package_version,
  $jre_name = $rundeck::params::jre_name,
  $jre_version = $rundeck::params::jre_version
) inherits rundeck::params {

  # validate parameters here

  class { 'rundeck::install': } ->
  class { 'rundeck::config': } ~>
  class { 'rundeck::service': } ->
  Class['rundeck']
}
