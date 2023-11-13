# @api private
#
# @summary This private class is called from `rundeck` to manage the configuration.
#
class rundeck::config {
  File {
    owner  => $rundeck::user,
    group  => $rundeck::group,
    mode   => $rundeck::file_default_mode,
  }

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)
  $auth_config      = deep_merge($rundeck::params::auth_config, $rundeck::auth_config)

  $logs_dir       = $framework_config['framework.logs.dir']
  $rdeck_base     = $framework_config['rdeck.base']
  $projects_dir   = $framework_config['framework.projects.dir']
  $properties_dir = $framework_config['framework.etc.dir']
  $plugin_dir     = $framework_config['framework.libext.dir']

  File[$rundeck::rdeck_home] ~> File[$rundeck::framework_config['framework.ssh.keypath']]

  if $manage_home {
    file { $rdeck_home:
      ensure  => directory,
    }
  } elsif ! defined_with_params(File[$rdeck_home], { 'ensure' => 'directory' }) {
    fail('when rundeck::manage_home = false a file definition for the home directory must be included outside of this module.')
  }

  if $rundeck::sshkey_manage {
    file { $framework_config['framework.ssh.keypath']:
      mode    => '0600',
    }
  }

  file { $rundeck::service_logs_dir:
    ensure  => directory,
  }

  ensure_resource(file, $projects_dir, { 'ensure' => 'directory' })
  ensure_resource(file, $plugin_dir, { 'ensure'   => 'directory' })

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
    content => epp($auth_template),
    require => File[$properties_dir],
  }

  file { "${properties_dir}/log4j.properties":
    content => template($log_properties_template),
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

  if ($rdeck_profile_template) {
    file { "${properties_dir}/profile":
      content => template($rdeck_profile_template),
      require => File[$properties_dir],
    }
  }

  if ($rdeck_override_template) {
    file { "${overrides_dir}/${service_name}":
      content => template($rdeck_override_template),
    }
  }

  contain rundeck::config::global::framework
  contain rundeck::config::global::project
  contain rundeck::config::global::rundeck_config
  contain rundeck::config::global::file_keystore

  Class['rundeck::config::global::framework']
  -> Class['rundeck::config::global::project']
  -> Class['rundeck::config::global::rundeck_config']
  -> Class['rundeck::config::global::file_keystore']

  if $ssl_enabled {
    contain rundeck::config::global::ssl
    Class['rundeck::config::global::rundeck_config']
    -> Class['rundeck::config::global::ssl']
  }

  create_resources(rundeck::config::project, $projects)

  if versioncmp( $package_ensure, '3.0.0' ) < 0 {
    class { 'rundeck::config::global::web':
      security_role                => $security_role,
      session_timeout              => $session_timeout,
      security_roles_array_enabled => $security_roles_array_enabled,
      security_roles_array         => $security_roles_array,
      require                      => Class['rundeck::install'],
    }
  }

  if !empty($kerberos_realms) {
    file { "${properties_dir}/krb5.conf":
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => template('rundeck/krb5.conf.erb'),
      require => File[$properties_dir],
    }
  }
}
