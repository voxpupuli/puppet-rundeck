# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::install
#
# This private class installs the rundeck package and its dependencies
#
class rundeck::install(
  $package_source  = $rundeck::package_source,
  $package_ensure  = $rundeck::package_ensure,
  $package_name    = $rundeck::package_name,
  $manage_yum_repo = $rundeck::manage_yum_repo,
  $rdeck_home      = $rundeck::rdeck_home,
  $user            = $rundeck::user,
  $group           = $rundeck::group,
  $manage_user     = $rundeck::manage_user,
  $manage_group    = $rundeck::manage_group,
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)
  $projects_dir = $framework_config['framework.projects.dir']
  $plugin_dir = $framework_config['framework.libext.dir']

  case $::osfamily {
    'RedHat': {
      if $manage_yum_repo == true {
        yumrepo { 'bintray-rundeck':
          baseurl  => 'http://dl.bintray.com/rundeck/rundeck-rpm/',
          descr    => 'bintray rundeck repo',
          enabled  => '1',
          gpgcheck => '0',
          priority => '1',
          before   => Package['rundeck'],
        }
      }
      $package_list = [ $package_name, "${package_name}-config", ]
    }
    'Debian': {
      $version = regsubst($package_ensure, '^(\d+)-(\d+)-GA$', '\1')

        archive { "/tmp/rundeck-${package_ensure}.deb":
          ensure => present,
          source => "${package_source}/rundeck-${package_ensure}.deb",
        }
      $package_list = [ $package_name, ]
    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }
  
  if $package_source {
    package { $package_list:
      ensure => $package_ensure,
      source => "${package_source}/${title}-",
    }
  } else {
    package { $package_list:
      ensure => $package_ensure,
    }
  }

  if $manage_group {
    ensure_resource('group', $group, { 'ensure' => 'present' } )
  }

  if $manage_user {
    ensure_resource('user', $user, { 'ensure' => 'present' } )
  }

  file { $rdeck_home:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  ensure_resource(file, $projects_dir, {'ensure' => 'directory', 'owner' => $user, 'group' => $group})
  ensure_resource(file, $plugin_dir, {'ensure'   => 'directory', 'owner' => $user, 'group' => $group})
}
