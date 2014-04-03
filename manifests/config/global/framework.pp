# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config used to manage the framework properties of rundeck
#
class rundeck::config::global::framework(
  $server_name     = $rundeck::params::server_name,
  $server_hostname = $rundeck::params::server_hostname,
  $server_port     = $rundeck::params::server_port,
  $server_url      = $rundeck::params::server_url,
  $cli_username    = $rundeck::params::cli_username,
  $cli_password    = $rundeck::params::cli_password,
  $rdeck_base      = $rundeck::params::rdeck_base,
  $projects_dir    = $rundeck::params::projects_dir,
  $properties_dir  = $rundeck::params::properties_dir,
  $var_dir         = $rundeck::params::var_dir,
  $tmp_dir         = $rundeck::params::tmp_dir,
  $logs_dir        = $rundeck::params::logs_dir,
  $plugin_dir      = $rundeck::params::plugin_dir,
  $ssh_keypath     = $rundeck::params::ssh_keypath,
  $ssh_user        = $rundeck::params::ssh_user,
  $ssh_timeout     = $rundeck::params::ssh_timeout,
  $user            = $rundeck::params::user,
  $group           = $rundeck::params::group

) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $properties_file = "${properties_dir}/framework.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group } )

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir]
  }

  ini_setting { 'framework.server.name':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.name',
    value   => $server_name,
    require => File[$properties_file]
  }

  ini_setting { 'framework.server.hostname':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.hostname',
    value   => $server_hostname,
    require => File[$properties_file]
  }

  ini_setting { 'framework.server.port':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.port',
    value   => $server_port,
    require => File[$properties_file]
  }

  ini_setting { 'framework.server.url':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.url',
    value   => $server_url,
    require => File[$properties_file]
  }

  ini_setting { 'framework.server.username':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.username',
    value   => $cli_username,
    require => File[$properties_file]
  }

  ini_setting { 'framework.server.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.server.password',
    value   => $cli_password,
    require => File[$properties_file]
  }

  ini_setting { 'global rdeck.base':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'rdeck.base',
    value   => $rdeck_base,
    require => File[$properties_file]
  }

  ini_setting { 'framework.projects.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.projects.dir',
    value   => $projects_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.etc.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.etc.dir',
    value   => $properties_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.var.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.var.dir',
    value   => $var_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.tmp.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.tmp.dir',
    value   => $tmp_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.logs.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.logs.dir',
    value   => $logs_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.libext.dir':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.libext.dir',
    value   => $plugin_dir,
    require => File[$properties_file]
  }

  ini_setting { 'framework.ssh.keypath':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.ssh.keypath',
    value   => $ssh_keypath,
    require => File[$properties_file]
  }

  ini_setting { 'framework.ssh.user':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.ssh.user',
    value   => $ssh_user,
    require => File[$properties_file]
  }

  ini_setting { 'framework.ssh.timeout':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'framework.ssh.timeout',
    value   => $ssh_timeout,
    require => File[$properties_file]
  }

}