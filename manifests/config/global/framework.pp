# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config used to manage the framework properties of rundeck
#
class rundeck::config::global::framework(
  $properties_dir   = $rundeck::config::properties_dir,
  $user             = $rundeck::config::user,
  $group            = $rundeck::config::group

) {

  $properties_file = "${properties_dir}/framework.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group } )

  $framework_config = merge($rundeck::params::framework_config, $rundeck::framework_config)

  file { $properties_file:
    ensure  => present,
    content => template('rundeck/framework.properties.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir]
  }

}
