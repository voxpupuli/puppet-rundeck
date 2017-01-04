# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config used to manage the framework properties of rundeck
#
class rundeck::config::global::framework(
  $group            = $rundeck::config::group,
  $properties_dir   = $rundeck::config::properties_dir,
  $user             = $rundeck::config::user,
  $ssl_enabled      = $rundeck::config::ssl_enabled,
  $ssl_port         = $rundeck::config::ssl_port
) {

  $framework_config_base = merge($rundeck::params::framework_config, $rundeck::framework_config)

  if $ssl_enabled and $ssl_port == '' {
    $framework_config_port = { 'framework.server.port' => '4443' }
    $framework_config_url = { 'framework.server.url' => "https://${::fqdn}:4443" }
  }
  elsif $ssl_enabled and $ssl_port != '' {
    $framework_config_port = { 'framework.server.port' => $ssl_port }
    $framework_config_url = { 'framework.server.url' => "https://${::fqdn}:${ssl_port}" }
  }
  else {
    $framework_config_port = { 'framework.server.port' => '4440' }
    $framework_config_url = { 'framework.server.url' => "http://${::fqdn}:4440" }
  }

  $properties_file = "${properties_dir}/framework.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group } )

  $framework_config = merge($framework_config_base, $framework_config_url, $framework_config_port)

  file { $properties_file:
    ensure  => present,
    content => template('rundeck/framework.properties.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

}
