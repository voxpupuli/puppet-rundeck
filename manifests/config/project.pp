# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define rundeck::config::project
#
# This definition is used to configure rundeck projects
#
# === Parameters
#
# [*file_copier_provider*]
#  The type of proivder that will be used for copying files to each of the nodes
#
# [*node_executor_provider*]
#  The type of provider that will be used to gather node resources
#
# [*resource_sources*]
#  A hash of rundeck::config::resource_source that will be used to specifiy the node
#  resources for this project
#
# [*ssh_keypath*]
#   The path the the ssh key that will be used by the ssh/scp providers
#
# [*projects_dir*]
#   The directory where rundeck is configured to store project information
#
# === Examples
#
# Create and manage a rundeck project:
#
# rundeck::config::project { 'test project':
#  ssh_keypath            => '/var/lib/rundeck/.ssh/id_rsa',
#  file_copier_provider   => 'jsch-scp',
#  node_executor_provider => 'jsch-ssh',
#  resource_sources       => $resource_hash
# }
#
define rundeck::config::project(
  $file_copier_provider   = $rundeck::params::file_copier_provider,
  $node_executor_provider = $rundeck::params::node_executor_provider,
  $resource_sources       = $rundeck::params::resource_sources,
  $framework_config       = $rundeck::framework_config,
  $user                   = $rundeck::user,
  $group                  = $rundeck::group
) {

  include rundeck::params

  $framework_properties = deep_merge($rundeck::params::framework_config, $framework_config)

  $ssh_keypath      = $framework_properties['framework.ssh.keypath']
  $projects_dir     = $framework_properties['framework.projects.dir']

  validate_absolute_path($ssh_keypath)
  validate_re($file_copier_provider, ['jsch-scp','script-copy','stub'])
  validate_re($node_executor_provider, ['jsch-ssh', 'script-exec', 'stub'])
  validate_hash($resource_sources)
  validate_absolute_path($projects_dir)
  validate_re($user, '[a-zA-Z0-9]{3,}')
  validate_re($group, '[a-zA-Z0-9]{3,}')

  $project_dir = "${projects_dir}/${name}"
  $properties_file = "${project_dir}/etc/project.properties"

  file {  $project_dir :
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0775',
    require => File[$projects_dir],
  }

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    require => File["${project_dir}/etc"]
  }

  file { "${project_dir}/var":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => File[$project_dir]
  }

  file { "${project_dir}/etc":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => File[$project_dir]
  }

  ini_setting { "${name}::project.name":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.name',
    value   => $name,
    require => File[$properties_file]
  }

  ini_setting { "${name}::project.ssh-authentication":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-authentication',
    value   => 'privateKey',
    require => File[$properties_file]
  }

  ini_setting { "${name}::project.ssh-keypath":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-keypath',
    value   => $ssh_keypath,
    require => File[$properties_file]
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
    require => File[$properties_file]
  }

  ini_setting { "${name}::service.NodeExecutor.default.provider":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'service.NodeExecutor.default.provider',
    value   => $node_executor_provider,
    require => File[$properties_file]
  }
}
