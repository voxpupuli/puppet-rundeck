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
# [*user*]
#   The user that rundeck is installed as.
#
# [*group*]
#   The group permission that rundeck is installed as.
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
  $framework_config       = {},
  $file_copier_provider   = '',
  $node_executor_provider = '',
  $resource_sources       = '',
  $ssh_keypath            = '',
  $projects_dir           = '',
  $user                   = '',
  $group                  = '',
) {

  include rundeck::params

  $framework_properties = merge($rundeck::params::framework_defaults, $framework_config)

  if "x${ssh_keypath}x" == 'xx' {
    $skp = $framework_properties['framework.ssh.keypath']
  } else {
    $skp = $ssh_keypath
  }

  if "x${file_copier_provider}x" == 'xx' {
    $fcp = $rundeck::params::file_copier_provider
  } else {
    $fcp = $file_copier_provider
  }

  if "x${node_executor_provider}x" == 'xx' {
    $nep = $rundeck::params::node_executor_provider
  } else {
    $nep = $node_executor_provider
  }

  if "x${resource_sources}x" == 'xx' {
    $res_sources = $rundeck::params::resource_sources
  } else {
    $res_sources = $resource_sources
  }

  if "x${projects_dir}x" == 'xx' {
    $pr = $framework_properties['framework.projects.dir']
  } else {
    $pr = $projects_dir
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

  validate_absolute_path($skp)
  validate_re($fcp, ['jsch-scp','script-copy','stub'])
  validate_re($nep, ['jsch-ssh', 'script-exec', 'stub'])
  validate_hash($res_sources)
  validate_absolute_path($pr)
  validate_re($u, '[a-zA-Z0-9]{3,}')
  validate_re($g, '[a-zA-Z0-9]{3,}')

  $project_dir = "${pr}/${name}"
  $properties_file = "${project_dir}/etc/project.properties"

  ensure_resource(file, $pr, {'ensure' => 'directory', 'owner' => $user, 'group' => $group})

  file { $properties_file:
    ensure  => present,
    owner   => $u,
    group   => $g,
    require => File["${project_dir}/etc"]
  }

  file { "${project_dir}/var":
    ensure  => directory,
    owner   => $u,
    group   => $g,
    require => File[$pr]
  }

  file { "${project_dir}/etc":
    ensure  => directory,
    owner   => $u,
    group   => $g,
    require => File[$project_dir]
  }

  ini_setting { 'project.name':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.name',
    value   => $name,
    require => File[$properties_file]
  }

  ini_setting { 'project.ssh-authentication':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-authentication',
    value   => 'privateKey',
    require => File[$properties_file]
  }

  ini_setting { 'project.ssh-keypath':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.ssh-keypath',
    value   => $skp,
    require => File[$properties_file]
  }

  create_resources(rundeck::config::resource_source, $res_sources)

  #TODO: there are more settings to be added here for both filecopier and nodeexecutor
  ini_setting { 'service.FileCopier.default.provider':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'service.FileCopier.default.provider',
    value   => $fcp,
    require => File[$properties_file]
  }

  ini_setting { 'service.NodeExecutor.default.provider':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'service.NodeExecutor.default.provider',
    value   => $nep,
    require => File[$properties_file]
  }
}
