# == Class rundeck::install
#
# This private class installs the rundeck package and it's dependencies
#
class rundeck::install(
  $jre_name           = $rundeck::jre_name,
  $jre_version        = $rundeck::jre_version,
  $package_version    = $rundeck::package_version,
  $package_sourcetype = $rundeck::package_sourcetype,
  $package_sourcerepo = $rundeck::package_sourcerepo
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('package', $jre_name, {'ensure' => $jre_version} )

  case $package_sourcetype {
    'repo': {
      #TODO: configure bintray as a package repo
    }
    'custom': {
      #TODO: add only-if for exec's

      case $::osfamily {
        'RedHat': {
          exec { 'download rundeck-config package':
            command => "/usr/bin/wget ${package_sourcerepo}/rundeck-config-${package_version}.noarch.rpm -O /tmp/rundeck-config-${package_version}.noarch.rpm",
            require => Package[$jre_name]
          }

          exec { 'download rundeck package':
            command => "/usr/bin/wget ${package_sourcerepo}/rundeck-${package_version}.noarch.rpm -O /tmp/rundeck-${package_version}.noarch.rpm",
            require => Package[$jre_name]
          }

          exec { 'install rundeck package':
            command => "/usr/bin/yum -y install /tmp/rundeck-config-${package_version}*.rpm /tmp/rundeck-${package_version}*.rpm",
            require => [ Package[$jre_name], Exec['download rundeck-config package'], Exec['download rundeck package'] ]
          }
        }
        'Debian': {
          exec { 'download rundeck package':
            command => "/usr/bin/wget ${package_sourcerepo}/rundeck-${package_version}.deb -O /tmp/rundeck-${package_version}.deb",
            unless  => "/usr/bin/test -f /tmp/rundeck-${package_version}.deb"
          }

          exec { 'install rundeck package':
            command => "/usr/bin/dpkg -i /tmp/rundeck-${package_version}.deb",
            onlyif  => "/usr/bin/test `dpkg-query --list | grep rundeck | awk '{print $3}'` = `echo \"${package_version}\" | cut -d '-' -f 1`",
            require => [ Exec['download rundeck package'], Package[$jre_name] ]
          }
        }
        default: {
          err("The osfamily: ${::osfamily} is not supported")
        }
      }
    }
    default: { }
  }

}
