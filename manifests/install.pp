# @api private
#
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
    }

    if $rundeck::user != 'rundeck' {
      user { 'rundeck':
        ensure => absent,
      }
    }
  }

  case $facts['os']['family'] {
    'RedHat': {
      if $rundeck::manage_repo {
        $rundeck::repo_config.each | String $_repo_name, Hash $_attributes| {
          yumrepo { $_repo_name:
            *      => $_attributes,
            before => Package['rundeck'],
          }
        }
      }

      package { 'rundeck':
        ensure => $rundeck::package_ensure,
        notify => Class['rundeck::service'],
      }
    }
    'Debian': {
      if $rundeck::manage_repo {
        include apt

        $rundeck::repo_config.each | String $_repo_name, Hash $_attributes | {
          apt::source { $_repo_name:
            *      => $_attributes,
            before => Package['rundeck'],
          }
        }

        Class['Apt::Update'] -> Package['rundeck']
      }

      package { 'rundeck':
        ensure => $rundeck::package_ensure,
        notify => Class['rundeck::service'],
      }
    }
    default: {
      err("The osfamily: ${facts['os']['family']} is not supported")
    }
  }
}
