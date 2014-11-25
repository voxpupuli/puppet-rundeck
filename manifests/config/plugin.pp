# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define rundeck::config::plugin
#
# This definition is used to install jars for rundeck's plugins
#
# === Parameters
#
# [*source*]
#   The http source or local path from which to get the jar plugin.
#
# [*plugin_dir*]
#   The rundeck directory where the plugins are installed to.
#
# [*user*]
#   The user that rundeck is installed as.
#
# [*group*]
#   The group permission that rundeck is installed as.
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
define rundeck::config::plugin(
  $source,
  $plugin_dir = '',
  $user       = '',
  $group      = ''
) {

  include rundeck::params

  if "x${plugin_dir}x" == 'xx' {
    $pd = $rundeck::params::framework_config['framework.libext.dir']
  } else {
    $pd = $plugin_dir
  }

  if "x${user}x" == 'xx' {
    $u = $rundeck::params::user
  } else {
    $u = $user
  }

  if "x${group}x" == 'xx' {
    $g = $rundeck::params::group
  } else {
    $g = $group
  }

  validate_string($source)
  validate_absolute_path($pd)
  validate_re($u, '[a-zA-Z0-9]{3,}')
  validate_re($g, '[a-zA-Z0-9]{3,}')

  ensure_resource(file, $pd, {'ensure' => 'directory', 'owner' => $u, 'group' => $g})

  exec { "download plugin ${name}":
    command => "/usr/bin/wget ${source} -O ${pd}/${name}",
    unless  => "/bin/ls -l /var/lib/rundeck/libext/ | grep ${name}"
  }

  file { "${pd}/${name}":
    ensure  => present,
    mode    => '0644',
    owner   => $u,
    group   => $g,
    require => Exec["download plugin ${name}"]
  }

}
