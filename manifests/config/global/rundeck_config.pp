# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT
#
# == Class rundeck::config::global::rundeck_config
#
# This private class is called from rundeck::config used to manage the rundeck-config properties
#
class rundeck::config::global::rundeck_config (
  $clustermode_enabled     = $rundeck::clustermode_enabled,
  $file_keystorage_dir     = $rundeck::file_keystorage_dir,
  $grails_server_url       = $rundeck::grails_server_url,
  $group                   = $rundeck::group,
  $key_storage_type        = $rundeck::key_storage_type,
  $mail_config             = $rundeck::mail_config,
  $preauthenticated_config = $rundeck::preauthenticated_config,
  $projects_storage_type   = $rundeck::projects_storage_type,
  $properties_dir          = $rundeck::properties_dir,
  $rd_loglevel             = $rundeck::loglevel,
  $rdeck_base              = $rundeck::rdeck_base,
  $rdeck_config_template   = $rundeck::rdeck_config_template,
  $rss_enabled             = $rundeck::rss_enabled,
  $security_config         = $rundeck::security_config,
  $user                    = $rundeck::user,
) {

  assert_private()

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  file { "${properties_dir}/rundeck-config.properties":
    ensure => absent,
  }

  file { "${properties_dir}/rundeck-config.groovy":
    ensure  => file,
    content => template($rdeck_config_template),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
    notify  => Service['rundeckd'],
  }
}
