# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::project
#
# This private class is called from rundeck::config used to manage the default project properties
#
class rundeck::config::global::project (
  $group                 = $rundeck::group,
  $projects_description  = $rundeck::projects_description,
  $projects_dir          = $rundeck::projects_dir,
  $projects_organization = $rundeck::projects_organization,
  $properties_dir        = $rundeck::properties_dir,
  $user                  = $rundeck::user,
) {

  assert_private()

  $properties_file = "${properties_dir}/project.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  Ini_setting {
    ensure  => present,
    path    => $properties_file,
    section => '',
    require => File[$properties_file],
  }

  file { $properties_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

  ini_setting { 'project.dir':
    setting => 'project.dir',
    value   => "${projects_dir}/\${project.name}",
  }

  ini_setting { 'project.etc.dir':
    setting => 'project.etc.dir',
    value   => "${projects_dir}/\${project.name}/etc",
  }

  ini_setting { 'project.resources.file':
    setting => 'project.resources.file',
    value   => "${projects_dir}/\${project.name}/etc/resources.xml",
  }

  ini_setting { 'project.description':
    setting => 'project.description',
    value   => $projects_organization,
  }

  ini_setting { 'project.organization':
    setting => 'project.organization',
    value   => $projects_description,
  }
}
