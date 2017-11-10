# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install {

  assert_private()

  $manage_repo        = $rundeck::manage_repo
  $package_ensure     = $rundeck::package_ensure
  $repo_yum_source    = $rundeck::repo_yum_source
  $repo_yum_gpgkey    = $rundeck::repo_yum_gpgkey
  $repo_apt_source    = $rundeck::repo_apt_source
  $repo_apt_key_id    = $rundeck::repo_apt_key_id
  $repo_apt_keyserver = $rundeck::repo_apt_keyserver
  $rdeck_home         = $rundeck::rdeck_home

  $framework_config = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)
  $projects_dir     = $framework_config['framework.projects.dir']
  $plugin_dir       = $framework_config['framework.libext.dir']

  $user     = $rundeck::user
  $group    = $rundeck::group
  $user_id  = $rundeck::user_id
  $group_id = $rundeck::group_id

  File {
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  case $::osfamily {
    'RedHat': {
      if $manage_repo {
        yumrepo { 'bintray-rundeck':
          baseurl  => $repo_yum_source,
          descr    => 'bintray rundeck repo',
          enabled  => '1',
          gpgcheck => '1',
          gpgkey   => $repo_yum_gpgkey,
          priority => '1',
          before   => Package['rundeck'],
        }
      }

      ensure_packages(['rundeck', 'rundeck-config'], {'ensure' => $package_ensure, notify => Class['rundeck::service'] } )
    }
    'Debian': {
      if $manage_repo {
        include apt
        apt::source { 'bintray-rundeck':
          location => $repo_apt_source,
          release  => '/',
          repos    => '',
          key      => {
            id     => $repo_apt_key_id,
            server => $repo_apt_keyserver,
          },
          before   => Package['rundeck'],
        }
      }
      ensure_packages(['rundeck'], {'ensure' => $package_ensure, notify => Class['rundeck::service'], require => Class['apt::update'] } )
    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }

  if $group == 'rundeck' and $group_id == '' {
    ensure_resource('group', 'rundeck', { 'ensure' => 'present' } )
  }
  elsif $group == 'rundeck' and $group_id != '' {
    ensure_resource('group', 'rundeck', { 'ensure' => 'present', 'gid' => $group_id } )
  }
  elsif $group != 'rundeck' and $group_id != '' {
    ensure_resource('group', $group, { 'ensure' => 'present', 'gid' => $group_id } )

    group { 'rundeck':
      ensure => absent,
    }
  }
  else {
    ensure_resource('group', $group, { 'ensure' => 'present' } )

    group { 'rundeck':
      ensure => absent,
    }
  }

  if $user == 'rundeck' and $user_id == '' {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group] } )
  }
  elsif $user == 'rundeck' and $user_id != '' and $group_id != '' {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group], 'uid' => $user_id, 'gid' => $group_id } )
  }
  elsif $user != 'rundeck' and $user_id != '' and $group_id != '' {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group], 'uid' => $user_id, 'gid' => $group_id } )

    user { 'rundeck':
      ensure => absent,
    }
  }
  else {
    ensure_resource('user', $user, { 'ensure' => 'present', 'groups' => [$group] } )

    user { 'rundeck':
      ensure => absent,
    }
  }

  File[$rdeck_home] ~> File[$framework_config['framework.ssh.keypath']]

  file { $rdeck_home:
    ensure  => directory,
  }

  if $::rundeck::sshkey_manage {
    file { $framework_config['framework.ssh.keypath']:
      mode    => '0600',
    }
  }

  Package['rundeck'] -> File[$rundeck::service_logs_dir]

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
