# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

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
  String $source,
  Enum['present', 'absent'] $ensure = 'present',
) {
  include rundeck
  include archive

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)

  $user = $rundeck::user
  $group = $rundeck::group
  $plugin_dir = $framework_config['framework.libext.dir']

  if $ensure == 'present' {
    archive { "download plugin ${name}":
      ensure  => present,
      source  => $source,
      path    => "${plugin_dir}/${name}",
      require => File[$plugin_dir],
      before  => File["${plugin_dir}/${name}"],
    }

    file { "${plugin_dir}/${name}":
      mode  => '0644',
      owner => $user,
      group => $group,
    }
  }
  elsif $ensure == 'absent' {
    file { "${plugin_dir}/${name}":
      ensure => 'absent',
    }
  }
}
