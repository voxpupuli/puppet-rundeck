# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::ssl
#
# This private class is called from rundeck::config used to manage the ssl properties if ssl is enabled
#
class rundeck::config::global::ssl (
  $group               = $rundeck::group,
  $key_password        = $rundeck::key_password,
  $keystore            = $rundeck::keystore,
  $keystore_password   = $rundeck::keystore_password,
  $properties_dir      = $rundeck::properties_dir,
  $service_name        = $rundeck::service_name,
  $truststore          = $rundeck::truststore,
  $truststore_password = $rundeck::truststore_password,
  $user                = $rundeck::user,
) {

  assert_private()

  $properties_file = "${properties_dir}/ssl/ssl.properties"

  ensure_resource('file', $properties_dir, {
    'ensure' => 'directory',
    'owner'  => $user,
    'group'  => $group
  } )
  ensure_resource('file', "${properties_dir}/ssl", {
    'ensure'  => 'directory',
    'owner'   => $user,
    'group'   => $group,
    'require' => File[$properties_dir]
    } )

  Ini_setting {
    ensure  => present,
    path    => $properties_file,
    section => '',
    notify  => Service['rundeckd'],
    require => File[$properties_file],
  }

  file { $properties_file:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    notify  => Service['rundeckd'],
    require => File[$properties_dir],
  }

  ini_setting { 'keystore':
    setting => 'keystore',
    value   => $keystore,
  }

  ini_setting { 'keystore.password':
    setting => 'keystore.password',
    value   => $keystore_password,
  }

  ini_setting { 'key.password':
    setting => 'key.password',
    value   => $key_password,
  }

  ini_setting { 'truststore':
    setting => 'truststore',
    value   => $truststore,
  }

  ini_setting { 'truststore.password':
    setting => 'truststore.password',
    value   => $truststore_password,
  }
}
