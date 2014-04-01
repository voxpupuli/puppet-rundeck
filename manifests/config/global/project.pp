#
class rundeck::config::global::project(
  $projects_root = $rundeck::params::projects_root,
  $projects_organization = $rundeck::params::projects_default_org,
  $projects_description = $rundeck::params::projects_default_desc,
  $properties_dir = $rundeck::params::properties_dir
) inherits rundeck::params {

  $properties_file = "${properties_dir}/project.properties"

  ini_setting { 'project.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.dir',
    value   => "${projects_root}/\${project.name}"
  }

  ini_setting { 'project.etc.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.etc.dir',
    value   => "${projects_root}/\${project.name}/etc"
  }

  ini_setting { 'project.resources.file':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.resources.file',
    value   => "${projects_root}/\${project.name}/etc/resources.xml"
  }

  ini_setting { 'project.description':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.description',
    value   => $projects_organization
  }

  ini_setting { 'project.organization':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'project.organization',
    value   => $projects_description
  }
}