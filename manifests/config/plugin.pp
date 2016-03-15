# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT
#
# == Define rundeck::config::plugin
#
# This definition is used to install jars for rundeck's plugins
#
# === Parameters
#
# [*ensure*]
#   Set present or absent to add or remove the plugin
#
# [*source*]
#   The http source or local path from which to get the jar plugin.
#
# [*plugin_config*]
#   A hash of key/value pairs to be added to framework.properies
#   for the plugin
#
# === Examples
#
# Install a custom plugin:
#
# rundeck::config::plugin { 'hipchat-plugin':
#  name   => 'rundeck-hipchat-plugin-1.0.0.jar',
#  source => 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar'
# }
#
define rundeck::config::plugin (
  $source,
  $ensure         = 'present',
  $plugin_config  = {},
) {

  include '::rundeck'
  include '::archive'

  $group          = $::rundeck::group
  $plugin_dir     = $::rundeck::plugin_dir
  $properties_dir = $::rundeck::properties_dir
  $user           = $::rundeck::user

  validate_hash($plugin_config)
  validate_string($source)
  validate_re($ensure, ['^present$', '^absent$'])

  file { "${plugin_dir}/${name}":
    ensure => $ensure,
    mode   => '0644',
    owner  => $user,
    group  => $group,
  }

  if $ensure == 'present' {
    archive { "download plugin ${name}":
      ensure  => present,
      source  => $source,
      path    => "${plugin_dir}/${name}",
      require => File[$plugin_dir],
      before  => File["${plugin_dir}/${name}"],
    }

    concat::fragment { "framework.properties+20_${name}":
      target  => "${properties_dir}/framework.properties",
      content => template('rundeck/framework.properties-plugin.erb'),
      order   => 20,
    }
  }
}
