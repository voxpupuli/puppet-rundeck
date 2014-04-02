#
define rundeck::config::plugin(
  $source,
  $plugin_dir = '',
  $user       = '',
  $group      = ''
) {

  include rundeck::params

  if "x${plugin_dir}x" == 'xx' {
    $pd = $rundeck::params::plugin_dir
  } else {
    $pd = $plugin_dir
  }

  if "x${user}x" == 'xx' {
    $u = $rundeck::params::user
  } else {
    $u = $user
  }

  if "x${group}x" == 'xx' {
    $g = $rundeck::params::user
  } else {
    $g = $group
  }

  validate_string($source)
  validate_absolute_path($pd)
  validate_re($u, '[a-zA-Z0-9]{3,}')
  validate_re($g, '[a-zA-Z0-9]{3,}')

  ensure_resource(file, $pd, {'ensure' => 'directory'})

  exec { "download plugin ${name}":
    command => "/usr/bin/wget ${source} -O ${pd}/${name}"
  }

  file { "${pd}/${name}":
    ensure  => present,
    mode    => '0600',
    owner   => $u,
    group   => $g,
    require => Exec["download plugin ${name}"]
  }

}