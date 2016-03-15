# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config used to manage the framework properties of rundeck
#
class rundeck::config::global::framework (
  $auth_config      = $rundeck::auth_config,
  $group            = $rundeck::group,
  $logs_dir         = $rundeck::logs_dir,
  $plugin_dir       = $rundeck::plugin_dir,
  $projects_dir     = $rundeck::projects_dir,
  $properties_dir   = $rundeck::properties_dir,
  $rdeck_base       = $rundeck::rdeck_base,
  $server_hostname  = $rundeck::server_hostname,
  $server_name      = $rundeck::server_name,
  $server_port      = $rundeck::server_port,
  $server_url       = $rundeck::server_url,
  $server_uuid      = $rundeck::server_uuid,
  $ssh_keypath      = $rundeck::ssh_keypath,
  $ssh_timeout      = $rundeck::ssh_timeout,
  $ssh_user         = $rundeck::ssh_user,
  $user             = $rundeck::user,
) {

  assert_private()

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group } )

  concat { "${properties_dir}/framework.properties":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

  concat::fragment { 'framework.properties+10_main':
    target  => "${properties_dir}/framework.properties",
    content => template('rundeck/framework.properties.erb'),
    order   => 10,
  }
}
