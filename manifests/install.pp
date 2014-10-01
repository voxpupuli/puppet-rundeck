# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install(
  $jre_name           = $rundeck::jre_name,
  $jre_version        = $rundeck::jre_version,
  $package_version    = $rundeck::package_version,
  $package_source     = $rundeck::package_source,
  $package_ensure     = $rundeck::package_ensure,
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('package', $jre_name, {'ensure' => $jre_version} )

  case $::osfamily {
    'RedHat': {
      yumrepo { 'bintray-rundeck':
        baseurl  => 'http://dl.bintray.com/rundeck/rundeck-rpm/',
        descr    => 'bintray rundeck repo',
        enabled  => '1',
        gpgcheck => '0',
        priority => '1',
        before   => [ Package["rundeck-config-${package_version}"],Package["rundeck-${package_version}"] ],
      }

      ensure_resource('package', "rundeck-config-${package_version}", {'ensure' => $package_ensure} )
      ensure_resource('package', "rundeck-${package_version}", {'ensure' => $package_ensure} )
    }
    'Debian': {
      exec { 'download rundeck package':
        command => "/usr/bin/wget ${package_source}/rundeck-${package_version}.deb -O /tmp/rundeck-${package_version}.deb",
        unless  => "/usr/bin/test -f /tmp/rundeck-${package_version}.deb"
      }
      exec { 'install rundeck package':
        command => "/usr/bin/dpkg -i /tmp/rundeck-${package_version}.deb",
        unless  => "/usr/bin/dpkg -l | grep rundeck | grep ${package_version}",
        require => [ Exec['download rundeck package'], Package[$jre_name] ]
      }
    }
    default: {
      err("The osfamily: ${::osfamily} is not supported")
    }
  }
}
