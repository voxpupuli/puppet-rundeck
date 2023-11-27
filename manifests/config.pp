# @api private
#
# @summary This class is called from rundeck to manage the configuration.
#
class rundeck::config {
  assert_private()

  $framework_config = $rundeck::framework_config

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
      ensure  => file,
      content => epp($rundeck::log_properties_template),
      require => File[$properties_dir, $rundeck::service_logs_dir],
      ;
  }

  if $rundeck::manage_default_admin_policy {
    rundeck::config::aclpolicyfile { 'admin':
      acl_policies   => $rundeck::admin_policies,
      owner          => $rundeck::user,
      group          => $rundeck::group,
      properties_dir => $properties_dir,
    }
  }

  if $rundeck::manage_default_api_policy {
    rundeck::config::aclpolicyfile { 'apitoken':
      acl_policies   => $rundeck::api_policies,
      owner          => $rundeck::user,
      group          => $rundeck::group,
      properties_dir => $properties_dir,
    }
  }

  if ($rundeck::override_template) {
    file { "${rundeck::override_dir}/${rundeck::service_name}":
      ensure  => file,
      content => epp($rundeck::override_template),
    }
  }

  contain rundeck::config::jaas_auth
  contain rundeck::config::framework

  file { "${properties_dir}/project.properties":
    ensure => absent,
  }

  file { "${properties_dir}/rundeck-config.properties":
    ensure  => file,
    content => epp($rundeck::config_template),
  }

  if $rundeck::ssl_enabled {
    contain rundeck::config::ssl
  }
}
