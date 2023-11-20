# @api private
#
# @summary This class is called from rundeck to manage the configuration.
#
class rundeck::config {
  assert_private()

  $properties_dir = $rundeck::framework_config['framework.etc.dir']

  File {
    owner => $rundeck::user,
    group => $rundeck::group,
  }

  if $rundeck::manage_home {
    file { $rundeck::home_dir:
      ensure => directory,
      mode   => '0755',
    }
  }

  [$rundeck::service_logs_dir, $properties_dir].each |$_path| {
    file { $_path:
      ensure => directory,
      mode   => '0755',
    }
  }

  file { "${properties_dir}/log4j2.properties":
    content => epp($rundeck::log_properties_template),
    require => File[$properties_dir],
  }

  if $rundeck::manage_default_admin_policy {
    rundeck::config::resource::aclpolicyfile { 'admin':
      acl_policies   => $rundeck::admin_policies,
      owner          => $rundeck::user,
      group          => $rundeck::group,
      properties_dir => $properties_dir,
      template_file  => $rundeck::acl_template,
    }
  }

  if $rundeck::manage_default_api_policy {
    rundeck::config::resource::aclpolicyfile { 'apitoken':
      acl_policies   => $rundeck::api_policies,
      owner          => $rundeck::user,
      group          => $rundeck::group,
      properties_dir => $properties_dir,
      template_file  => $rundeck::acl_template,
    }
  }

  if ($rundeck::override_template) {
    file { "${rundeck::override_dir}/${rundeck::service_name}":
      content => epp($rundeck::override_template),
    }
  }

  contain rundeck::config::jaas_auth
  contain rundeck::config::framework
  # contain rundeck::config::global::project
  # contain rundeck::config::global::rundeck_config
  # contain rundeck::config::global::file_keystore

  # Class['rundeck::config::global::framework']
  # -> Class['rundeck::config::global::project']
  # -> Class['rundeck::config::global::rundeck_config']
  # -> Class['rundeck::config::global::file_keystore']

  # if $ssl_enabled {
  #   contain rundeck::config::global::ssl
  #   Class['rundeck::config::global::rundeck_config']
  #   -> Class['rundeck::config::global::ssl']
  # }

  # create_resources(rundeck::config::project, $projects)

  # if versioncmp( $package_ensure, '3.0.0' ) < 0 {
  #   class { 'rundeck::config::global::web':
  #     security_role                => $security_role,
  #     session_timeout              => $session_timeout,
  #     security_roles_array_enabled => $security_roles_array_enabled,
  #     security_roles_array         => $security_roles_array,
  #     require                      => Class['rundeck::install'],
  #   }
  # }

  # if !empty($kerberos_realms) {
  #   file { "${properties_dir}/krb5.conf":
  #     owner   => $user,
  #     group   => $group,
  #     mode    => '0640',
  #     content => template('rundeck/krb5.conf.erb'),
  #     require => File[$properties_dir],
  #   }
  # }
}
