# == Class rundeck::config
#
# This private class is called from rundeck to manage the configuration
#
class rundeck::config(
  $auth_type             = $rundeck::auth_type,
  $auth_users            = $rundeck::auth_users,
  $properties_dir        = $rundeck::properties_dir,
  $user                  = $rundeck::user,
  $group                 = $rundeck::group,
  $ssl_enabled           = $rundeck::ssl_enabled,
  $server_name           = $rundeck::server_name,
  $server_hostname       = $rundeck::server_hostname,
  $server_port           = $rundeck::server_port,
  $server_url            = $rundeck::server_url,
  $cli_username          = $rundeck::cli_username,
  $cli_password          = $rundeck::cli_password,
  $rdeck_base            = $rundeck::rdeck_base,
  $var_dir               = $rundeck::var_dir,
  $tmp_dir               = $rundeck::tmp_dir,
  $logs_dir              = $rundeck::logs_dir,
  $plugin_dir            = $rundeck::plugin_dir,
  $ssh_keypath           = $rundeck::ssh_keypath,
  $ssh_user              = $rundeck::ssh_user,
  $ssh_timeout           = $rundeck::ssh_timeout,
  $projects_dir          = $rundeck::projects_dir,
  $projects_organization = $rundeck::projects_default_org,
  $projects_description  = $rundeck::projects_default_desc,
  $rd_loglevel           = $rundeck::rd_loglevel,
  $rss_enabled           = $rundeck::rss_enabled,
  $grails_server_url     = $rundeck::grails_server_url,
  $dataSource_dbCreate   = $rundeck::dataSource_dbCreate,
  $dataSource_url        = $rundeck::dataSource_url,
  $keystore              = $rundeck::keystore,
  $keystore_password     = $rundeck::keystore_password,
  $key_password          = $rundeck::key_password,
  $truststore            = $rundeck::truststore,
  $truststore_password   = $rundeck::truststore_password
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  if $auth_type == 'file' {
    file { "${properties_dir}/jaas-loginmodule.conf":
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => template('rundeck/jaas-loginmodule.conf.erb'),
      require => File[$properties_dir]
    }

    file { "${properties_dir}/realm.properties":
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => template('rundeck/realm.properties.erb'),
      require => File[$properties_dir]
    }
  }

  file { "${properties_dir}/log4j.properties":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('rundeck/log4j.properties.erb'),
    require => File[$properties_dir]
  }

  file { "${properties_dir}/admin.aclpolicy":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('rundeck/admin.aclpolicy.erb'),
    require => File[$properties_dir]
  }

  file { "${properties_dir}/apitoken.aclpolicy":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('rundeck/apitoken.aclpolicy.erb'),
    require => File[$properties_dir]
  }

  file { "${properties_dir}/profile":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('rundeck/profile.erb'),
    require => File[$properties_dir]
  }

  class { 'rundeck::config::global::framework': } ->
  class { 'rundeck::config::global::project': } ->
  class { 'rundeck::config::global::rundeck_config': } ->
  class { 'rundeck::config::global::ssl': }
}
