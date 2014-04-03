# == Class rundeck::config::global::ssl
#
# This private class is called from rundeck::config used to manage the ssl properties if ssl is enabled
#
class rundeck::config::global::ssl(
  $keystore            = $rundeck::params::keystore,
  $keystore_password   = $rundeck::params::keystore_password,
  $key_password        = $rundeck::params::key_password,
  $truststore          = $rundeck::params::truststore,
  $truststore_password = $rundeck::params::truststore_password,
  $properties_dir      = $rundeck::params::properties_dir,
  $user                = $rundeck::params::user,
  $group               = $rundeck::params::group
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $properties_file = "${properties_dir}/ssl/ssl.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory'} )
  ensure_resource('file', "${properties_dir}/ssl", {'ensure' => 'directory', 'require' => File[$properties_dir]} )

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir]
  }

  ini_setting { 'keystore':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'keystore',
    value   => $keystore,
    require => File[$properties_file]
  }

  ini_setting { 'keystore.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'keystore.password',
    value   => $keystore_password,
    require => File[$properties_file]
  }

  ini_setting { 'key.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'key.password',
    value   => $key_password,
    require => File[$properties_file]
  }

  ini_setting { 'truststore':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'truststore',
    value   => $truststore,
    require => File[$properties_file]
  }

  ini_setting { 'truststore.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'truststore.password',
    value   => $truststore_password,
    require => File[$properties_file]
  }
}