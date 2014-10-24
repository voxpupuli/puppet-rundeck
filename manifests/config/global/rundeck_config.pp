# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::rundeck_config
#
# This private class is called from rundeck::config used to manage the rundeck-config properties
#
class rundeck::config::global::rundeck_config(
  $rd_loglevel         = $rundeck::config::loglevel,
  $rdeck_base          = $rundeck::config::rdeck_base,
  $rss_enabled         = $rundeck::config::rss_enabled,
  $grails_server_url   = $rundeck::config::grails_server_url,
  $dataSource_dbCreate = $rundeck::config::dataSource_dbCreate,
  $dataSource_url      = $rundeck::config::dataSource_url,
  $properties_dir      = $rundeck::config::properties_dir,
  $user                = $rundeck::config::user,
  $group               = $rundeck::config::group,
  $mail_config         = $rundeck::config::mail_config,
  $security_config     = $rundeck::config::security_config
) {

  $properties_file = "${properties_dir}/rundeck-config.groovy"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )

  file { "${properties_dir}/rundeck-config.properties":
    ensure => absent
  }

  file { $properties_file:
    ensure  => present,
    content => template('rundeck/rundeck-config.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir]
  }
}
