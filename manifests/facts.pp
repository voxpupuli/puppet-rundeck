# == Class: rundeck::facts
#
# Class to add some facts for rundeck. They have been added as an external fact
# because we do not want to distrubute these facts to all systems.
#
# === Parameters
# 
# [*ensure*] - ensure that these facts are added to the system
#
# === Examples
#
# class { 'rundeck::facts': }
#
class rundeck::facts(
  $ensure = 'present',
) {

  if $::puppetversion =~ /Puppet Enterprise/ {
    $ruby_bin = '/opt/puppet/bin/ruby'
    $dir      = 'puppetlabs/'
  } else {
    $ruby_bin = '/usr/bin/env ruby'
    $dir      = ''
  }

  if ! defined(File["/etc/${dir}facter"]) {
    file { "/etc/${dir}facter":
      ensure  => directory,
    }
  }
  if ! defined(File["/etc/${dir}facter/facts.d"]) {
    file { "/etc/${dir}facter/facts.d":
      ensure  => directory,
    }
  }

  file { "/etc/${dir}facter/facts.d/rundeck_facts.rb":
    ensure  => $ensure,
    content => template('rundeck/facts.rb.erb'),
    mode    => '0500',
  }
}
