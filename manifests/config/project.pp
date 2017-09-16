# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT
#
# == Define rundeck::config::project
#
# This definition is used to configure rundeck projects
#
# === Parameters
#
# [*file_copier_provider*]
#  The type of proivder that will be used for copying files to each of the nodes
#
# [*framework_config*]
#  Rundeck config
#
# [*group*]
#  Rundeck group
#
# [*node_executor_provider*]
#  The type of provider that will be used to gather node resources
#
# [*projects_dir*]
#  The directory where rundeck is configured to store project information
#
# [*resource_sources*]
#  A hash of rundeck::config::resource_source that will be used to specify the node resources for this project
#
# [*scm_import_properties*]
#  A hash of name value pairs representing properties for the scm-import.properties file
#
# [*ssh_keypath*]
#  The path to the ssh key that will be used by the ssh/scp providers
#
# [*user*]
#  Rundeck user
#
# === Examples
#
# Create and manage a rundeck project:
#
# rundeck::config::project { 'test project':
#  ssh_keypath            => '/var/lib/rundeck/.ssh/id_rsa',
#  file_copier_provider   => 'jsch-scp',
#  node_executor_provider => 'jsch-ssh',
#  resource_sources       => $resource_hash,
#  scm_import_properties  => $scm_import_properties_hash
# }
#
define rundeck::config::project (
  $file_copier_provider   = $rundeck::file_copier_provider,
  $framework_config       = $rundeck::framework_config,
  $group                  = $rundeck::group,
  $node_executor_provider = $rundeck::node_executor_provider,
  $node_executor_settings = {},
  $projects_dir           = undef,
  $resource_sources       = $rundeck::resource_sources,
  $scm_import_properties  = {},
  $scm_export_properties  = {},
  $ssh_keypath            = undef,
  $user                   = $rundeck::user,
) {

  include ::rundeck

  $framework_properties = deep_merge($rundeck::params::framework_config, $rundeck::framework_config, $framework_config)

  $_ssh_keypath = $ssh_keypath ? {
    undef   => $framework_properties['framework.ssh.keypath'],
    default => $ssh_keypath,
  }

  $_projects_dir = $projects_dir ? {
    undef   => $framework_properties['framework.projects.dir'],
    default => $projects_dir,
  }

  validate_absolute_path($_ssh_keypath)
  validate_re($file_copier_provider, ['^jsch-scp$','^script-copy$','^stub$'])
  validate_hash($resource_sources)
  validate_hash($scm_import_properties)
  validate_absolute_path($_projects_dir)
  validate_re($user, '[a-zA-Z0-9]{3,}')
  validate_re($group, '[a-zA-Z0-9]{3,}')

  $project_dir = "${_projects_dir}/${name}"
  $properties_file = "${project_dir}/etc/project.properties"
  $scm_import_properties_file = "${project_dir}/etc/scm-import.properties"
  $scm_export_properties_file = "${project_dir}/etc/scm-export.properties"

  file { $project_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0775',
  }

  file { $properties_file:
    ensure => file,
    owner  => $user,
    group  => $group,
  }

  file { $scm_import_properties_file:
    ensure  => present,
    content => template('rundeck/scm-import.properties.erb'),
    owner   => $user,
    group   => $group,
    replace => false,
  }

  file { $scm_export_properties_file:
    ensure  => present,
    content => template('rundeck/scm-export.properties.erb'),
    owner   => $user,
    group   => $group,
    require => File["${project_dir}/etc"],
    replace => false,
  }

  file { "${project_dir}/var":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => File[$project_dir],
  }

  file { "${project_dir}/etc":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => File[$project_dir],
  }

  ini_setting { "${name}::project.name":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.name',
    value   => $name,
    require => File[$properties_file],
  }

  ini_setting { "${name}::project.ssh-authentication":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-authentication',
    value   => 'privateKey',
    require => File[$properties_file],
  }

  ini_setting { "${name}::project.ssh-keypath":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-keypath',
    value   => $_ssh_keypath,
    require => File[$properties_file],
  }

  $resource_source_defaults = {
    project_name => $name,
  }


  create_resources(rundeck::config::resource_source, $resource_sources, $resource_source_defaults)

  #TODO: there are more settings to be added here for both filecopier and nodeexecutor
  ini_setting { "${name}::service.FileCopier.default.provider":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'service.FileCopier.default.provider',
    value   => $file_copier_provider,
    require => File[$properties_file],
  }

  ini_setting { "${name}::service.NodeExecutor.default.provider":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'service.NodeExecutor.default.provider',
    value   => $node_executor_provider,
    require => File[$properties_file],
  }

  $node_executor_settings_defaults = {
    path    => $properties_file,
    require => File[$properties_file],
  }

  create_ini_settings($node_executor_settings, $node_executor_settings_defaults)
}
