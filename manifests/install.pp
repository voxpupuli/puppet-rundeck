# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT
#
# == Class rundeck::install
#
# This private class installs the rundeck package and its dependencies
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
  $user               = $rundeck::user
  $group              = $rundeck::group
  $manage_user        = $rundeck::manage_user
  $manage_group       = $rundeck::manage_group
  $user_id            = $rundeck::user_id
  $group_id           = $rundeck::group_id

  if $manage_group {
    group { $group:
      ensure => present,
      gid    => $group_id,
      system => true,
    }

    if $group != 'rundeck' {
      group { 'rundeck':
        ensure => absent,
      }
    }
  }

  if $manage_user {
    user { $user:
      ensure => present,
      groups => [$group],
      uid    => $user_id,
      gid    => $group_id,
      system => true,
      before => File['/var/rundeck'],
    }

    if $user != 'rundeck' {
      user { 'rundeck':
        ensure => absent,
      }
    }
  }

  case $facts['os']['family'] {
    'RedHat': {
      if $manage_repo {
        yumrepo { 'rundeck':
          baseurl       => $repo_yum_source,
          descr         => 'rundeck repo',
          enabled       => '1',
          gpgcheck      => '0',
          gpgkey        => $repo_yum_gpgkey,
          repo_gpgcheck => '1',
          priority      => '1',
          before        => Package['rundeck'],
        }
      }

      ensure_packages(['rundeck'], { 'ensure' => $package_ensure, notify => Class['rundeck::service'] })
    }
    'Debian': {
      if $manage_repo {
        include apt
        apt::source { 'rundeck':
          location => $repo_apt_source,
          release  => 'any',
          repos    => 'main',
          key      => {
            id     => $repo_apt_key_id,
            source => $rundeck::repo_apt_gpgkey,
            server => $repo_apt_keyserver,
          },
          before   => Package['rundeck'],
        }
      }
      ensure_packages(['rundeck'], { 'ensure' => $package_ensure, notify => Class['rundeck::service'], require => Class['apt::update'] })
    }
    default: {
      err("The osfamily: ${facts['os']['family']} is not supported")
    }
  }

  # Leave this one here, to avoid notifying service when permissions change
  file { '/var/rundeck':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    recurse => true,
    require => Package['rundeck'],
  }
}
