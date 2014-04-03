# == Class rundeck::config
#
# This private class is called from rundeck to manage the configuration
#
class rundeck::config(
  $auth_type             = $rundeck::params::auth_type,
  $auth_users            = $rundeck::params::auth_users,
  $properties_dir        = $rundeck::params::properties_dir,
  $user                  = $rundeck::params::user,
  $group                 = $rundeck::params::group,
  $ssl_enabled           = $rundeck::ssl_enabled,
  $server_name           = $rundeck::params::server_name,
  $server_hostname       = $rundeck::params::server_hostname,
  $server_port           = $rundeck::params::server_port,
  $server_url            = $rundeck::params::server_url,
  $cli_username          = $rundeck::params::cli_username,
  $cli_password          = $rundeck::params::cli_password,
  $rdeck_base            = $rundeck::params::rdeck_base,
  $var_dir               = $rundeck::params::var_dir,
  $tmp_dir               = $rundeck::params::tmp_dir,
  $logs_dir              = $rundeck::params::logs_dir,
  $plugin_dir            = $rundeck::params::plugin_dir,
  $ssh_keypath           = $rundeck::params::ssh_keypath,
  $ssh_user              = $rundeck::params::ssh_user,
  $ssh_timeout           = $rundeck::params::ssh_timeout,
  $projects_dir          = $rundeck::params::projects_dir,
  $projects_organization = $rundeck::params::projects_default_org,
  $projects_description  = $rundeck::params::projects_default_desc,
  $rd_loglevel           = $rundeck::params::rd_loglevel,
  $rss_enabled           = $rundeck::params::rss_enabled,
  $grails_server_url     = $rundeck::params::grails_server_url,
  $dataSource_dbCreate   = $rundeck::params::dataSource_dbCreate,
  $dataSource_url        = $rundeck::params::dataSource_url,
  $keystore              = $rundeck::params::keystore,
  $keystore_password     = $rundeck::params::keystore_password,
  $key_password          = $rundeck::params::key_password,
  $truststore            = $rundeck::params::truststore,
  $truststore_password   = $rundeck::params::truststore_password
) inherits rundeck::params {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('file', $properties_dir, {'ensure' => 'directory'} )

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

  class { 'rundeck::config::global::framework':
    server_name     => $server_name,
    server_hostname => $server_hostname,
    server_port     => $server_port,
    server_url      => $server_url,
    cli_username    => $cli_username,
    cli_password    => $cli_password,
    rdeck_base      => $rdeck_base,
    projects_dir    => $projects_dir,
    properties_dir  => $properties_dir,
    var_dir         => $var_dir,
    tmp_dir         => $tmp_dir,
    logs_dir        => $logs_dir,
    plugin_dir      => $plugin_dir,
    ssh_keypath     => $ssh_keypath,
    ssh_user        => $ssh_user,
    ssh_timeout     => $ssh_timeout
  }

  class { 'rundeck::config::global::project':
    projects_dir          => $projects_dir,
    projects_organization => $projects_organization,
    projects_description  => $projects_description,
    properties_dir        => $rundeck::properties_dir
  }

  class { 'rundeck::config::global::rundeck_config':
    rd_loglevel         => $rd_loglevel,
    rdeck_base          => $rdeck_base,
    rss_enabled         => $rss_enabled,
    grails_server_url   => $grails_server_url,
    dataSource_dbCreate => $dataSource_dbCreate,
    dataSource_url      => $dataSource_url,
    properties_dir      => $properties_dir
  }

  class { 'rundeck::config::global::ssl':
    keystore            => $keystore,
    keystore_password   => $keystore_password,
    key_password        => $key_password,
    truststore          => $truststore,
    truststore_password => $truststore_password,
    properties_dir      => $properties_dir
  }
}
