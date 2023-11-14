# @summary This class is called from rundeck for install.
#
class rundeck::install {
  assert_private()

  if $rundeck::manage_group {
    group { $rundeck::group:
      ensure => present,
      gid    => $rundeck::group_id,
      system => true,
    }

    if $rundeck::group != 'rundeck' {
      group { 'rundeck':
        ensure => absent,
      }
    }
  }

  if $rundeck::manage_user {
    user { $rundeck::user:
      ensure => present,
      groups => [$rundeck::group],
      uid    => $rundeck::user_id,
      gid    => $rundeck::group_id,
      system => true,
      before => File['/var/rundeck'],
    }

    if $rundeck::user != 'rundeck' {
      user { 'rundeck':
        ensure => absent,
      }
    }
  }

  if $rundeck::manage_repo {
    $rundeck::repo_config.each() | String $_resource_type, Hash $_resources | {
      if downcase($_resource_type) == 'apt::source' {
        Class['Apt::Update'] -> Package['rundeck']
      }
      create_resources($_resource_type, $_resources, { 'before' => Package['rundeck'] })
    }
  }

  ensure_packages(['rundeck'], { 'ensure' => $rundeck::package_ensure, notify => Class['rundeck::service'] })

  # Leave this one here, to avoid notifying service when permissions change
  file { '/var/rundeck':
    ensure  => directory,
    owner   => $rundeck::user,
    group   => $rundeck::group,
    mode    => '0640',
    recurse => true,
    require => Package['rundeck'],
  }
}
