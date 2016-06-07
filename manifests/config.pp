# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config
#
# This private class is called from `rundeck` to manage the configuration
#
class rundeck::config(
  $acl_policies                             = $rundeck::acl_policies,
  $acl_template                             = $rundeck::acl_template,
  $api_policies                             = $rundeck::api_policies,
  $api_template                             = $rundeck::api_template,
  $auth_template                            = $rundeck::auth_template,
  $auth_types                               = $rundeck::auth_types,
  $clustermode_enabled                      = $rundeck::clustermode_enabled,
  $database_config                          = $rundeck::database_config,
  $file_keystorage_dir                      = $rundeck::file_keystorage_dir,
  $file_keystorage_keys                     = $rundeck::file_keystorage_keys,
  $grails_server_url                        = $rundeck::grails_server_url,
  $group                                    = $rundeck::group,
  $gui_config                               = $rundeck::gui_config,
  $java_home                                = $rundeck::java_home,
  $jvm_args                                 = $rundeck::jvm_args,
  $kerberos_realms                          = $rundeck::kerberos_realms,
  $key_password                             = $rundeck::key_password,
  $key_storage_type                         = $rundeck::key_storage_type,
  $keystore                                 = $rundeck::keystore,
  $keystore_password                        = $rundeck::keystore_password,
  $mail_config                              = $rundeck::mail_config,
  $manage_default_admin_policy              = $rundeck::manage_default_admin_policy,
  $manage_default_api_policy                = $rundeck::manage_default_api_policy,
  $preauthenticated_config                  = $rundeck::preauthenticated_config,
  $projects                                 = $rundeck::projects,
  $projects_description                     = $rundeck::projects_default_desc,
  $projects_organization                    = $rundeck::projects_default_org,
  $projects_storage_type                    = $rundeck::projects_storage_type,
  $rd_loglevel                              = $rundeck::rd_loglevel,
  $rdeck_config_template                    = $rundeck::rdeck_config_template,
  $rdeck_profile_template                   = $rundeck::rdeck_profile_template,
  $realm_template                           = $rundeck::realm_template,
  $rss_enabled                              = $rundeck::rss_enabled,
  $security_config                          = $rundeck::security_config,
  $security_role                            = $rundeck::security_role,
  $server_web_context                       = $rundeck::server_web_context,
  $service_logs_dir                         = $rundeck::service_logs_dir,
  $service_name                             = $rundeck::service_name,
  $session_timeout                          = $rundeck::session_timeout,
  $ssl_enabled                              = $rundeck::ssl_enabled,
  $truststore                               = $rundeck::truststore,
  $truststore_password                      = $rundeck::truststore_password,
  $user                                     = $rundeck::user,
  $rundeck_config_global_web_sec_roles_true = $rundeck::rundeck_config_global_web_sec_roles_true,
  $rundeck_config_global_web_sec_roles      = $rundeck::rundeck_config_global_web_sec_roles,
) inherits rundeck::params {

  File {
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)
  $auth_config      = deep_merge($rundeck::params::auth_config, $rundeck::auth_config)

  $logs_dir       = $framework_config['framework.logs.dir']
  $rdeck_base     = $framework_config['rdeck.base']
  $projects_dir   = $framework_config['framework.projects.dir']
  $properties_dir = $framework_config['framework.etc.dir']

  #
  # Checking if we need to deploy realm file
  #  ugly, I know. Fix it if you know better way to do that
  #
  if 'file' in $auth_types or 'ldap_shared' in $auth_types or 'active_directory_shared' in $auth_types {
    $_deploy_realm = true
  } else {
    $_deploy_realm = false
  }

  if $_deploy_realm {
    file { "${properties_dir}/realm.properties":
      content => template($realm_template),
      require => File[$properties_dir],
      notify  => Service[$service_name],
    }
  }

  if 'file' in $auth_types {
    $active_directory_auth_flag = 'sufficient'
    $ldap_auth_flag = 'sufficient'
  } else {
    if 'active_directory' in $auth_types {
      $active_directory_auth_flag = 'required'
      $ldap_auth_flag = 'sufficient'
    }
    elsif 'active_directory_shared' in $auth_types {
      $active_directory_auth_flag = 'requisite'
      $ldap_auth_flag = 'sufficient'
    }
    elsif 'ldap_shared' in $auth_types {
      $ldap_auth_flag = 'requisite'
    }
    elsif 'ldap' in $auth_types {
      $ldap_auth_flag = 'required'
    }
  }

  if 'active_directory' in $auth_types or 'ldap' in $auth_types {
    $ldap_login_module = 'JettyCachingLdapLoginModule'
  }
  elsif 'active_directory_shared' in $auth_types or 'ldap_shared' in $auth_types {
    $ldap_login_module = 'JettyCombinedLdapLoginModule'
  }
  file { "${properties_dir}/jaas-auth.conf":
    content => template($auth_template),
    require => File[$properties_dir],
  }

  file { "${properties_dir}/log4j.properties":
    content => template('rundeck/log4j.properties.erb'),
    notify  => Service[$service_name],
    require => File[$properties_dir],
  }

  if $manage_default_admin_policy {
    rundeck::config::aclpolicyfile { 'admin':
      acl_policies   => $acl_policies,
      owner          => $user,
      group          => $group,
      properties_dir => $properties_dir,
      template_file  => $acl_template,
    }
  }

  if $manage_default_api_policy {
    rundeck::config::aclpolicyfile { 'apitoken':
      acl_policies   => $api_policies,
      owner          => $user,
      group          => $group,
      properties_dir => $properties_dir,
      template_file  => $api_template,
    }
  }

  file { "${properties_dir}/profile":
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template($rdeck_profile_template),
    notify  => Service[$service_name],
    require => File[$properties_dir],
  }

  include '::rundeck::config::global::framework'
  include '::rundeck::config::global::project'
  include '::rundeck::config::global::rundeck_config'
  include '::rundeck::config::global::file_keystore'

  Class[rundeck::config::global::framework] ->
  Class[rundeck::config::global::project] ->
  Class[rundeck::config::global::rundeck_config] ->
  Class[rundeck::config::global::file_keystore]

  if $ssl_enabled {
    include '::rundeck::config::global::ssl'
    Class[rundeck::config::global::rundeck_config] ->
    Class[rundeck::config::global::ssl]
  }

  create_resources(rundeck::config::project, $projects)

  class { '::rundeck::config::global::web':
    security_role                            => $security_role,
    session_timeout                          => $session_timeout,
    rundeck_config_global_web_sec_roles_true => $rundeck_config_global_web_sec_roles_true,
    rundeck_config_global_web_sec_roles      => $rundeck_config_global_web_sec_roles,
    notify                                   => Service[$service_name],
  }

  if !empty($kerberos_realms) {
    file { "${properties_dir}/krb5.conf":
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => template('rundeck/krb5.conf.erb'),
      notify  => Service[$service_name],
      require => File[$properties_dir],
    }
  }
}
