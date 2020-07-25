# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::project
#
# This private class is called from rundeck::config used to manage the default project properties
#
class rundeck::config::global::project {
  assert_private()

  $group                 = $rundeck::config::group
  $projects_description  = $rundeck::config::projects_description
  $projects_dir          = $rundeck::config::projects_dir
  $projects_organization = $rundeck::config::projects_organization
  $properties_dir        = $rundeck::config::properties_dir
  $user                  = $rundeck::config::user

  $properties_file = "${properties_dir}/project.properties"

  ensure_resource('file', $properties_dir, { 'ensure' => 'directory', 'owner' => $user, 'group' => $group })

  file { $properties_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

  ini_setting { 'project.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.dir',
    value   => "${projects_dir}/\${project.name}",
    require => File[$properties_file],
  }

  ini_setting { 'project.etc.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.etc.dir',
    value   => "${projects_dir}/\${project.name}/etc",
    require => File[$properties_file],
  }

  ini_setting { 'project.resources.file':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.resources.file',
    value   => "${projects_dir}/\${project.name}/etc/resources.xml",
    require => File[$properties_file],
  }

  ini_setting { 'project.description':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.description',
    value   => $projects_description,
    require => File[$properties_file],
  }

  ini_setting { 'project.organization':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.organization',
    value   => $projects_organization,
    require => File[$properties_file],
  }
}
