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
#  A hash of rundeck::config::resource_source that will be used to specifiy the node resources for this project
#
# [*scm_import_properties*]
#  A hash of name value pairs representing properties for the scm-import.properties file
#
# [*ssh_keypath*]
#  The path the the ssh key that will be used by the ssh/scp providers
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
  $group                  = $rundeck::group,
  $node_executor_provider = $rundeck::node_executor_provider,
  $projects_dir           = $rundeck::projects_dir,
  $resource_sources       = $rundeck::resource_sources,
  $scm_import_properties  = $rundeck::scm_import_properties,
  $ssh_keypath            = $rundeck::ssh_keypath,
  $user                   = $rundeck::user,
) {

  include ::rundeck

  validate_re($file_copier_provider, ['^jsch-scp$','^script-copy$','^stub$'])
  validate_re($node_executor_provider, ['^jsch-ssh$', '^script-exec$', '^stub$'])
  validate_hash($resource_sources)
  validate_hash($scm_import_properties)

  $project_dir = "${projects_dir}/${name}"
  $properties_file = "${project_dir}/etc/project.properties"
  $scm_import_properties_file = "${project_dir}/etc/scm-import.properties"

  File {
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0775',
    require => File[$properties_file],
  }

  Ini_setting {
    ensure  => present,
    path    => $properties_file,
    section => '',
    require => File[$properties_file],
  }

  file { $project_dir:
    ensure  => directory,
    require => File[$projects_dir],
  }

  file { $properties_file:
    require => File["${project_dir}/etc"],
  }

  file { $scm_import_properties_file:
    content => template('rundeck/scm-import.properties.erb'),
    replace => false,
    require => File["${project_dir}/etc"],
  }

  file { "${project_dir}/var":
    ensure  => directory,
    require => File[$project_dir],
  }

  file { "${project_dir}/etc":
    ensure  => directory,
    require => File[$project_dir],
  }

  ini_setting { "${name}::project.name":
    setting => 'project.name',
    value   => $name,
  }

  ini_setting { "${name}::project.ssh-authentication":
    setting => 'project.ssh-authentication',
    value   => 'privateKey',
  }

  ini_setting { "${name}::project.ssh-keypath":
    setting => 'project.ssh-keypath',
    value   => $ssh_keypath,
  }

  $resource_source_defaults = {
    project_name => $name,
  }

  create_resources(rundeck::config::resource_source, $resource_sources, $resource_source_defaults)

  #TODO: there are more settings to be added here for both filecopier and nodeexecutor
  ini_setting { "${name}::service.FileCopier.default.provider":
    setting => 'service.FileCopier.default.provider',
    value   => $file_copier_provider,
  }

  ini_setting { "${name}::service.NodeExecutor.default.provider":
    setting => 'service.NodeExecutor.default.provider',
    value   => $node_executor_provider,
  }
}
