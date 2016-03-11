# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install(
  $manage_yum_repo    = $rundeck::manage_yum_repo,
  $package_ensure     = $rundeck::package_ensure,
  $package_source     = $rundeck::package_source,
  $rdeck_home         = $rundeck::rdeck_home,
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)
  $projects_dir = $framework_config['framework.projects.dir']
  $plugin_dir = $framework_config['framework.libext.dir']

  $user = $rundeck::user
  $group = $rundeck::group

  File {
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

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

  if $group == 'rundeck' {
    ensure_resource('group', 'rundeck', { 'ensure' => 'present' } )
  } else {
    ensure_resource('group', $group, { 'ensure' => 'present' } )

    group { 'rundeck':
      ensure => absent,
    }
  }

  if $user == 'rundeck' {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group] } )
  } else {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group] } )

    user { 'rundeck':
      ensure => absent,
    }
  }

  file { $rdeck_home:
    ensure  => directory,
  } ~>
  file { $framework_config['framework.ssh.keypath']:
    mode    => '0600',
  }

  file { $rundeck::service_logs_dir:
    ensure  => directory,
  }

  file { '/var/rundeck/':
    ensure  => directory,
    recurse => true,
  }

  ensure_resource(file, $projects_dir, {'ensure' => 'directory'})
  ensure_resource(file, $plugin_dir, {'ensure'   => 'directory'})
}
