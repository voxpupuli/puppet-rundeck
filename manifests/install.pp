# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT
#
# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install (
  $group            = $rundeck::group,
  $manage_yum_repo  = $rundeck::manage_yum_repo,
  $package_ensure   = $rundeck::package_ensure,
  $package_source   = $rundeck::package_source,
  $plugin_dir       = $rundeck::plugin_dir,
  $projects_dir     = $rundeck::projects_dir,
  $rdeck_home       = $rundeck::rdeck_home,
  $service_logs_dir = $rundeck::service_logs_dir,
  $ssh_keypath      = $rundeck::ssh_keypath,
  $user             = $rundeck::user
) {

  assert_private()

  File {
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  case $::osfamily {
    'RedHat': {
      if str2bool($manage_yum_repo) {
        yumrepo { 'bintray-rundeck':
          baseurl  => 'http://dl.bintray.com/rundeck/rundeck-rpm/',
          descr    => 'bintray rundeck repo',
          enabled  => '1',
          gpgcheck => '0',
          priority => '1',
          before   => Package['rundeck'],
        }
      }

      ensure_resource('package', 'rundeck', {'ensure' => $package_ensure, notify => Class['rundeck::service'] } )
      ensure_resource('package', 'rundeck-config', {'ensure' => $package_ensure, notify => Class['rundeck::service'] } )
    }
    'Debian': {

      $version = inline_template("<% package_version = '${package_ensure}' %><%= package_version.split('-')[0] %>")

      if $::rundeck_version != $version {
        exec { 'download rundeck package':
          command => "/usr/bin/wget ${package_source}/rundeck-${package_ensure}.deb -O /tmp/rundeck-${package_ensure}.deb",
          unless  => "/usr/bin/test -f /tmp/rundeck-${package_ensure}.deb",
        }

        exec { 'stop rundeck service':
          command => '/usr/sbin/service rundeckd stop',
          unless  => "/bin/bash -c 'if pgrep -f RunServer > /dev/null; then echo 1; else echo 0; fi'",
        }

        exec { 'install rundeck package':
          command => "/usr/bin/dpkg --force-confold --ignore-depends 'java7-runtime' -i /tmp/rundeck-${package_ensure}.deb",
          unless  => "/usr/bin/dpkg -l | grep rundeck | grep ${version}",
          require => [ Exec['download rundeck package'], Exec['stop rundeck service'] ],
        }
      }

    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }

  ensure_resource('group', $group, { 'ensure' => 'present' } )
  ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group] } )

  file { $rdeck_home: }
  ->
  file { $ssh_keypath:
    ensure => file,
    mode   => '0600',
  }

  file { $service_logs_dir: }

  file { '/var/rundeck/':
    recurse => true,
  }

  ensure_resource(file, $projects_dir, {'ensure' => 'directory'})
  ensure_resource(file, $plugin_dir, {'ensure'   => 'directory'})
}
