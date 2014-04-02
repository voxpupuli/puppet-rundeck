#
class rundeck::config::global::rundeck_config(
  $rd_loglevel         = $rundeck::params::loglevel,
  $rdeck_base          = $rundeck::params::rdeck_base,
  $rss_enabled         = $rundeck::params::rss_enabled,
  $grails_server_url   = $rundeck::params::grails_server_url,
  $dataSource_dbCreate = $rundeck::params::dataSource_dbCreate,
  $dataSource_url      = $rundeck::params::dataSource_url,
  $properties_dir      = $rundeck::params::properties_dir
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $properties_file = "${properties_dir}/rundeck-config.properties"

  ini_setting { 'loglevel.default':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'loglevel.default',
    value   => $rd_loglevel
  }

  ini_setting { 'config rdeck.base':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'rdeck.base',
    value   => $rdeck_base
  }

  ini_setting { 'rss.enabled':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'rss.enabled',
    value   => $rss_enabled
  }

  ini_setting { 'grails.serverURL':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'grails.serverURL',
    value   => $grails_server_url
  }

  ini_setting { 'dataSource.dbCreate':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'dataSource.dbCreate',
    value   => $dataSource_dbCreate
  }

  ini_setting { 'dataSource.url':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'dataSource.url',
    value   => $dataSource_url
  }
}