#
define rundeck::config::project(
  $ssh_keypath = '',
  $file_copier_provider = '',
  $node_executor_provider = '',
  $resource_sources = '',
  $projects_root = ''
) {

  include rundeck::params

  if "x${ssh_keypath}x" == 'xx' {
    $skp = $rundeck::params::ssh_keypath
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

  if "x${projects_root}x" == 'xx' {
    $pr = $rundeck::params::projects_root
  } else {
    $pr = $projects_root
  }

  $project_dir = "${pr}/${name}"
  $properties_file = "${project_dir}/etc/project.properties"

  #TODO: validate params
  validate_string($name)
  validate_hash($res_sources)

  ensure_resource(file, $pr, {'ensure' => 'directory'})

  file { "${project_dir}/var":
    ensure  => directory,
    require => File[$pr]
  }

  file { "${project_dir}/etc":
    ensure  => directory,
    require => File[$project_dir]
  }

  file { $properties_file:
    ensure  => present,
    require => File["${project_dir}/etc"]
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

  #TODO: add defaults
  create_resources(rundeck::config::resource_source, $res_sources)

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