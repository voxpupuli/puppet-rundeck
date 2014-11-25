# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config
#
# This private class is called from `rundeck` to manage the configuration
#
class rundeck::config(
  $auth_types            = $rundeck::auth_types,
  $auth_users            = $rundeck::auth_users,
  $auth_template         = $rundeck::auth_template,
  $user                  = $rundeck::user,
  $group                 = $rundeck::group,
  $ssl_enabled           = $rundeck::ssl_enabled,
  $framework_config      = $rundeck::framework_config,
  $projects_organization = $rundeck::projects_default_org,
  $projects_description  = $rundeck::projects_default_desc,
  $rd_loglevel           = $rundeck::rd_loglevel,
  $rss_enabled           = $rundeck::rss_enabled,
  $clustermode_enabled   = $rundeck::clustermode_enabled,
  $grails_server_url     = $rundeck::grails_server_url,
  $database_config       = $rundeck::database_config,
  $keystore              = $rundeck::keystore,
  $keystore_password     = $rundeck::keystore_password,
  $key_password          = $rundeck::key_password,
  $truststore            = $rundeck::truststore,
  $truststore_password   = $rundeck::truststore_password,
  $service_logs_dir      = $rundeck::service_logs_dir,
  $service_name          = $rundeck::service_name,
  $mail_config           = $rundeck::mail_config,
  $security_config       = $rundeck::security_config,
  $acl_policies          = $rundeck::acl_policies
) inherits rundeck::params {

  $framework_properties = merge($rundeck::params::framework_defaults, $framework_config)
  $auth_config          = deep_merge($rundeck::params::auth_config, $rundeck::auth_config)

  $logs_dir = $framework_properties['framework.logs.dir']
  $rdeck_base = $framework_properties['rdeck.base']
  $projects_dir = $framework_properties['framework.projects.dir']
  $admin_user = $framework_properties['framework.server.username']
  $admin_password = $framework_properties['framework.server.password']
  $properties_dir = $framework_properties['framework.etc.dir']

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  if 'file' in $auth_types {
    file { "${properties_dir}/realm.properties":
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => template('rundeck/realm.properties.erb'),
      require => File[$properties_dir],
      notify  => Service[$service_name],
    }

    $active_directory_auth_flag = 'sufficient'
    $ldap_auth_flag = 'sufficient'
  }
  elsif 'active_directory' in $auth_types {
    $active_directory_auth_flag = 'required'
    $ldap_auth_flag = 'sufficient'
  }
  else {
    $ldap_auth_flag = 'required'
  }

  file { "${properties_dir}/jaas-auth.conf":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template($auth_template),
    require => File[$properties_dir]
  }

  file { "${properties_dir}/log4j.properties":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('rundeck/log4j.properties.erb'),
    notify  => Service[$service_name],
    require => File[$properties_dir]
  }

  file { "${properties_dir}/admin.aclpolicy":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template($rundeck::acl_template),
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
    notify  => Service[$service_name],
    require => File[$properties_dir]
  }

  ensure_resource('file', ['/etc/facter', '/etc/facter/facts.d'], {'ensure' => 'directory'})

  file { '/etc/facter/facts.d/rundeck_version':
    ensure => present,
    source => 'puppet:///modules/rundeck/rundeck_version',
    owner  => root,
    group  => root,
    mode   => '0755'
  }

  class { 'rundeck::config::global::framework': } ->
  class { 'rundeck::config::global::project': } ->
  class { 'rundeck::config::global::rundeck_config': } ->
  class { 'rundeck::config::global::ssl': }
}
