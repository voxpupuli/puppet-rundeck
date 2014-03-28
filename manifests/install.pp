# == Class rundeck::install
#
class rundeck::install {

  ensure_resource('package', $rundeck::jre_name, {'ensure' => $rundeck::jre_version} )

  # why isn't this in a package repo?

  case $::osfamily {
    'RedHat': {
      exec { 'download rundeck-config package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-config-${rundeck::package_version}.noarch.rpm -O /tmp/rundeck-config-${rundeck::package_version}.noarch.rpm",
        require => Package[$rundeck::jre_name]
      }

      exec { 'download rundeck package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-${rundeck::package_version}.noarch.rpm -O /tmp/rundeck-${rundeck::package_version}.noarch.rpm",
        require => Package[$rundeck::jre_name]
      }

      exec { 'install rundeck package':
        command => "/usr/bin/yum -y install /tmp/rundeck-config-${rundeck::package_version}*.rpm /tmp/rundeck-${rundeck::package_version}*.rpm",
        require => [ Package[$rundeck::jre_name], Exec['download rundeck-config package'], Exec['download rundeck package'] ]
      }
    }
    'Debian': {
      exec { 'download rundeck package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck-${rundeck::package_version}.deb -O /tmp/rundeck-${rundeck::package_version}.deb",
        unless  => "/usr/bin/test -f /tmp/rundeck-${rundeck::package_version}.deb"
      }

      exec { 'install rundeck package':
        command => "/usr/bin/dpkg -i /tmp/rundeck-${rundeck::package_version}.deb",
        require => [ Exec['download rundeck package'], Package[$rundeck::jre_name] ]
      }
    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }

}
