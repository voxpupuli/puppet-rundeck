# @api private
#
# @summary This class is called from rundeck to manage the configuration.
#
class rundeck::config {
  assert_private()

  $framework_config = deep_merge(lookup('rundeck::framework_config'), $rundeck::framework_config)
  $project_config   = deep_merge(lookup('rundeck::project_config'), $rundeck::project_config)

  $base_dir       = $framework_config['rdeck.base']
  $properties_dir = $framework_config['framework.etc.dir']

  File {
    owner => $rundeck::user,
    group => $rundeck::group,
  }

  if $rundeck::manage_home {
    file { $base_dir:
      ensure => directory,
      mode   => '0755',
    }
  }

  $framework_config.each |$_key, $_value| {
    if $_key =~ '.dir' {
      file { $_value:
        ensure => directory,
        mode   => '0755',
      }
    }
  }

  file {
    $rundeck::service_logs_dir:
      ensure => directory,
      mode   => '0755',
      ;
    "${properties_dir}/log4j2.properties":
      content => epp($rundeck::log_properties_template),
      require => File[$properties_dir, $rundeck::service_logs_dir],
      ;
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

  file { "${properties_dir}/project.properties":
    ensure  => file,
    content => epp('rundeck/project.properties.epp', { _project_config => $project_config }),
  }

  file { "${properties_dir}/rundeck-config.properties":
    ensure  => file,
    content => epp($rundeck::config_template),
  }

  # if $ssl_enabled {
  #   contain rundeck::config::global::ssl
  #   Class['rundeck::config::global::rundeck_config']
  #   -> Class['rundeck::config::global::ssl']
  # }

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
