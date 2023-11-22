# @api private
#
# @summary This private class is called from rundeck::config used to manage the ssl properties if ssl is enabled.
#
class rundeck::config::ssl {
  assert_private()

  $group               = $rundeck::group
  $key_password        = $rundeck::key_password
  $ssl_keyfile         = $rundeck::ssl_keyfile
  $ssl_certfile        = $rundeck::ssl_certfile
  $keystore            = $rundeck::keystore
  $keystore_password   = $rundeck::keystore_password
  $properties_dir      = $rundeck::config::properties_dir
  $service_name        = $rundeck::service_name
  $truststore          = $rundeck::truststore
  $truststore_password = $rundeck::truststore_password
  $user                = $rundeck::user

  $properties_file = "${properties_dir}/ssl/ssl.properties"

  ensure_resource('file', $properties_dir, {
      'ensure' => 'directory',
      'owner'  => $user,
      'group'  => $group
  })
  ensure_resource('file', "${properties_dir}/ssl", {
      'ensure'  => 'directory',
      'owner'   => $user,
      'group'   => $group,
      'require' => File[$properties_dir]
  })

  java_ks { "rundeck:${properties_dir}/ssl/keystore":
    ensure       => present,
    private_key  => $ssl_keyfile,
    certificate  => $ssl_certfile,
    password     => $keystore_password,
    destkeypass  => $key_password,
    trustcacerts => true,
  }
  -> java_ks { "rundeck:${properties_dir}/ssl/truststore":
    ensure       => present,
    private_key  => $ssl_keyfile,
    certificate  => $ssl_certfile,
    password     => $truststore_password,
    destkeypass  => $key_password,
    trustcacerts => true,
  }

  file { $properties_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

  ini_setting { 'keystore':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'keystore',
    value   => $keystore,
    require => File[$properties_file],
  }

  ini_setting { 'keystore.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'keystore.password',
    value   => $keystore_password,
    require => File[$properties_file],
  }

  ini_setting { 'key.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'key.password',
    value   => $key_password,
    require => File[$properties_file],
  }

  ini_setting { 'truststore':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'truststore',
    value   => $truststore,
    require => File[$properties_file],
  }

  ini_setting { 'truststore.password':
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => 'truststore.password',
    value   => $truststore_password,
    require => File[$properties_file],
  }
}