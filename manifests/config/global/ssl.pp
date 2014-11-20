# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::ssl
#
# This private class is called from rundeck::config used to manage the ssl properties if ssl is enabled
#
class rundeck::config::global::ssl(
  $keystore            = $rundeck::config::keystore,
  $keystore_password   = $rundeck::config::keystore_password,
  $key_password        = $rundeck::config::key_password,
  $truststore          = $rundeck::config::truststore,
  $truststore_password = $rundeck::config::truststore_password,
  $properties_dir      = $rundeck::config::properties_dir,
  $user                = $rundeck::config::user,
  $group               = $rundeck::config::group,
  $service_name        = $rundeck::service_name,
) {

  $properties_file = "${properties_dir}/ssl/ssl.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )
  ensure_resource('file', "${properties_dir}/ssl", {'ensure' => 'directory', 'owner' => $user, 'group' => $group, 'require' => File[$properties_dir]} )

  Ini_setting {
    notify => Service[$service_name],
  }

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    notify  => Service[$service_name],
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
