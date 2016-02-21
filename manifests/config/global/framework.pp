# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config and
# used to manage the framework properties of rundeck
#
class rundeck::config::global::framework(
  $properties_dir = $rundeck::config::properties_dir,
  $user           = $rundeck::config::user,
  $group          = $rundeck::config::group,
) {

  $properties_file = "${properties_dir}/framework.properties"

  ensure_resource('file', $properties_dir, {
    'ensure' => 'directory',
    'owner' => $user,
    'group' => $group } )

  $framework_config_base = merge($rundeck::params::framework_config, $rundeck::framework_config) # lint:ignore:80chars

  $default_port = $rundeck::ssl_enabled ? {
    true    => '4443',
    default => '4440',
  }
  $default_url = $rundeck::ssl_enabled ? {
    true    => "https://${::fqdn}:4443",
    default => "http://${::fqdn}:4440",
  }

  if $framework_config_base['framework.server.port'] == undef {
    $framework_config_port = { 'framework.server.port' => $default_port }
  } else {
    $framework_config_port = $framework_config_base['framework.server.port']
  }

  if $framework_config_base['framework.server.url'] == undef {
    $framework_config_url = { 'framework.server.url' => $default_url }
  } else {
    $framework_config_url = $framework_config_base['framework.server.url']
  }

  $framework_config = merge($framework_config_base, $framework_config_url, $framework_config_port) # lint:ignore:80chars

  file { $properties_file:
    ensure  => present,
    content => template('rundeck/framework.properties.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

}
