# @api private
#
# @summary This class is called from rundeck to manage the configuration.
#
class rundeck::config {
  assert_private()

  $_framework_defaults = {
    'rdeck.base'                => '/var/lib/rundeck',
    'framework.server.hostname' => $facts['networking']['hostname'],
    'framework.server.name'     => $facts['networking']['fqdn'],
    'framework.server.port'     => '4440',
    'framework.server.url'      => "http://${facts['networking']['fqdn']}:4440",
    'framework.etc.dir'         => '/etc/rundeck',
    'framework.var.dir'         => '/var/lib/rundeck/var',
    'framework.tmp.dir'         => '/var/lib/rundeck/var/tmp',
    'framework.logs.dir'        => '/var/lib/rundeck/var/logs',
    'framework.libext.dir'      => '/var/lib/rundeck/libext',
    'framework.ssh.keypath'     => '/var/lib/rundeck/.ssh/id_rsa',
    'framework.ssh.user'        => 'rundeck',
    'framework.ssh.timeout'     => '0',
    'rundeck.server.uuid'       => fqdn_uuid($facts['networking']['fqdn']),
  }

  $framework_config = $_framework_defaults + $rundeck::framework_config

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

  if $rundeck::override_template {
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
