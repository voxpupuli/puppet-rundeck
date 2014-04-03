# == Class rundeck::config::global::rundeck_config
#
# This private class is called from rundeck::config used to manage the rundeck-config properties
#
class rundeck::config::global::rundeck_config(
  $rd_loglevel         = $rundeck::params::loglevel,
  $rdeck_base          = $rundeck::params::rdeck_base,
  $rss_enabled         = $rundeck::params::rss_enabled,
  $grails_server_url   = $rundeck::params::grails_server_url,
  $dataSource_dbCreate = $rundeck::params::dataSource_dbCreate,
  $dataSource_url      = $rundeck::params::dataSource_url,
  $properties_dir      = $rundeck::params::properties_dir,
  $user                = $rundeck::params::user,
  $group               = $rundeck::params::group
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $properties_file = "${properties_dir}/rundeck-config.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir]
  }

  ini_setting { 'loglevel.default':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'loglevel.default',
    value   => $rd_loglevel,
    require => File[$properties_file]
  }

  ini_setting { 'config rdeck.base':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'rdeck.base',
    value   => $rdeck_base,
    require => File[$properties_file]
  }

  ini_setting { 'rss.enabled':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'rss.enabled',
    value   => $rss_enabled,
    require => File[$properties_file]
  }

  ini_setting { 'grails.serverURL':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'grails.serverURL',
    value   => $grails_server_url,
    require => File[$properties_file]
  }

  ini_setting { 'dataSource.dbCreate':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'dataSource.dbCreate',
    value   => $dataSource_dbCreate,
    require => File[$properties_file]
  }

  ini_setting { 'dataSource.url':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'dataSource.url',
    value   => $dataSource_url,
    require => File[$properties_file]
  }
}