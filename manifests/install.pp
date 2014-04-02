# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install(
  $jre_name        = $rundeck::jre_name,
  $jre_version     = $rundeck::jre_version,
  $package_version = $rundeck::package_version
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('package', $jre_name, {'ensure' => $jre_version} )

  # why isn't this in a package repo?

  #TODO: configure bintray as a package repo

  case $::osfamily {
    'RedHat': {
      exec { 'download rundeck-config package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-config-${package_version}.noarch.rpm -O /tmp/rundeck-config-${package_version}.noarch.rpm",
        require => Package[$jre_name]
      }

      exec { 'download rundeck package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-${package_version}.noarch.rpm -O /tmp/rundeck-${package_version}.noarch.rpm",
        require => Package[$jre_name]
      }

      exec { 'install rundeck package':
        command => "/usr/bin/yum -y install /tmp/rundeck-config-${package_version}*.rpm /tmp/rundeck-${package_version}*.rpm",
        require => [ Package[$jre_name], Exec['download rundeck-config package'], Exec['download rundeck package'] ]
      }
    }
    'Debian': {
      exec { 'download rundeck package':
        command => "/usr/bin/wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck-${package_version}.deb -O /tmp/rundeck-${package_version}.deb",
        unless  => "/usr/bin/test -f /tmp/rundeck-${package_version}.deb"
      }

      exec { 'install rundeck package':
        command => "/usr/bin/dpkg -i /tmp/rundeck-${package_version}.deb",
        require => [ Exec['download rundeck package'], Package[$jre_name] ]
      }
    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }

}
