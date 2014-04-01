# == Class rundeck::config
#
# This class is called from rundeck to manage the configuration
#
class rundeck::config(
  $auth_type = $rundeck::params::auth_type,
  $properties_dir = $rundeck::params::properties_dir
) inherits rundeck::params {

  #TODO: pass forward variables from init.pp
  #TODO: configure templates

  if $auth_type == 'ldap' {
    $jaas_file = ''
  } else {
    $jaas_file = 'jaas-loginmodule.conf'
  }

  anchor { 'rundeck::config::begin': } ->

  class { 'rundeck::config::global::framework': } ->
  class { 'rundeck::config::global::project': } ->
  class { 'rundeck::config::global::rundeck_config': } ->
  class { 'rundeck::config::global::ssl': } ->

  file { "${properties_dir}/${jaas_file}":
    owner   => 'rundeck',
    group   => 'rundeck',
    mode    => '0644',
    content => template("rundeck/${jaas_file}.erb")
  } ->

  anchor { 'rundeck::config::end': }

}
