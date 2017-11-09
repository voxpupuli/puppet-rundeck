# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::config::global::framework
#
# This private class is called from rundeck::config used to manage the framework properties of rundeck
#
class rundeck::config::global::framework {
  $group          = $rundeck::config::group
  $properties_dir = $rundeck::config::properties_dir
  $user           = $rundeck::config::user
  $ssl_enabled    = $rundeck::config::ssl_enabled
  $ssl_port       = $rundeck::config::ssl_port

  $_framework_config = merge($rundeck::params::framework_config, $rundeck::framework_config)

  # Make sure that we use framework.server.hostname when using non-standard
  # port, rather than hard-coding to fqdn
  $rundeck_hostname = $_framework_config['framework.server.hostname']
  $rundeck_port = $_framework_config['framework.server.port']

  if $ssl_enabled {
    $framework_config_port = { 'framework.server.port' => $ssl_port }
    $framework_config_url = { 'framework.server.url' => "https://${rundeck_hostname}:${ssl_port}" }
  } elsif $rundeck_hostname != $rundeck::params::framework_config['framework.server.hostname'] {
    $framework_config_port = undef
    $framework_config_url = { 'framework.server.url' => "http://${rundeck_hostname}:${rundeck_port}" }
  } else {
    $framework_config_port = undef
    $framework_config_url = undef
  }

  $properties_file = "${properties_dir}/framework.properties"

  ensure_resource('file', $properties_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group } )

  $framework_config = merge($_framework_config, $framework_config_url, $framework_config_port)

  file { $properties_file:
    ensure  => present,
    content => template('rundeck/framework.properties.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => File[$properties_dir],
  }

}
