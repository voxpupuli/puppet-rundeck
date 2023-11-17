# @api private
#
# @summary This private class is called from rundeck::config used to manage the rundeck-config properties.
#
class rundeck::config::global::rundeck_config {
  assert_private()

  $clustermode_enabled                  = $rundeck::config::clustermode_enabled
  $execution_mode                       = $rundeck::config::execution_mode
  $file_keystorage_dir                  = $rundeck::config::file_keystorage_dir
  $grails_server_url                    = $rundeck::config::grails_server_url
  $group                                = $rundeck::config::group
  $gui_config                           = $rundeck::config::gui_config
  $key_storage_config                   = $rundeck::config::key_storage_config
  $mail_config                          = $rundeck::config::mail_config
  $preauthenticated_config              = $rundeck::config::preauthenticated_config
  $properties_dir                       = $rundeck::config::properties_dir
  $quartz_job_threadcount               = $rundeck::config::quartz_job_threadcount
  $app_log_level                        = $rundeck::config::app_log_level
  $rdeck_base                           = $rundeck::config::rdeck_base
  $rdeck_config_template                = $rundeck::config::rdeck_config_template
  $rss_enabled                          = $rundeck::config::rss_enabled
  $security_config                      = $rundeck::config::security_config
  $storage_encrypt_config               = $rundeck::config::storage_encrypt_config
  $user                                 = $rundeck::config::user

  $properties_file = "${properties_dir}/rundeck-config.groovy"

  ensure_resource('file', $properties_dir, { 'ensure' => 'directory', 'owner' => $user, 'group' => $group })

  $database_config = merge($rundeck::params::database_config, $rundeck::config::database_config)

  file { "${properties_dir}/rundeck-config.properties":
    ensure => absent,
  }

  $_service_notify = $rundeck::config::service_restart ? {
    false => undef,
    default => Service[$rundeck::config::service_name]
  }
  file { $properties_file:
    ensure  => file,
    content => epp($rdeck_config_template),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
    notify  => $_service_notify,
  }
}
