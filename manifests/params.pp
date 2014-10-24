# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::params
#
# This class is meant to be called from `rundeck`
# It sets variables according to platform
#
class rundeck::params {

  case $::osfamily {
    'Debian': {
      $package_name = 'rundeck'
      $package_ensure = '2.2.3-1-GA'
      $service_name = 'rundeckd'
      $jre_name = 'openjdk-6-jre'
      $jre_ensure = 'installed'
    }
    'RedHat', 'Amazon': {
      $package_name = 'rundeck'
      $package_ensure = 'installed'
      $service_name = 'rundeckd'
      $jre_name = 'java-1.6.0-openjdk'
      $jre_ensure = 'installed'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $rdeck_base = '/var/lib/rundeck'
  $service_logs_dir = '/var/log/rundeck'

  $auth_type = 'file'
  $auth_users = {}

  $framework_config = {}

  $framework_defaults = {
    'framework.server.name'     => $::fqdn,
    'framework.server.hostname' => $::fqdn,
    'framework.server.port'     => '4440',
    'framework.server.url'      => "http://${::fqdn}:4440",
    'framework.server.username' => 'admin',
    'framework.server.password' => 'admin',
    'rdeck.base'                => '/var/lib/rundeck',
    'framework.projects.dir'    => '/var/rundeck/projects',
    'framework.etc.dir'         => '/etc/rundeck',
    'framework.var.dir'         => '/var/lib/rundeck/var',
    'framework.tmp.dir'         => '/var/lib/rundeck/var/tmp',
    'framework.logs.dir'        => '/var/lib/rundeck/logs',
    'framework.libext.dir'      => '/var/lib/rundeck/libext',
    'framework.ssh.keypath'     => '/var/lib/rundeck/.ssh/id_rsa',
    'framework.ssh.user'        => 'rundeck',
    'framework.ssh.timeout'     => '0'
  }

  $mail_config = {}

  $security_config = {
    'useHMacRequestTokens' => true,
    'apiCookieAccess'      => true
  }

  $projects_default_org = ''
  $projects_default_desc = ''

  $file_copier_provider = 'jsch-scp'
  $node_executor_provider = 'jsch-ssh'

  $url_cache = true
  $url_timeout = '30'

  $resource_format = 'resourcexml'
  $include_server_node = false
  $default_source_type = 'file'
  $default_resource_dir = '/'

  $script_args_quoted = true
  $script_interpreter = '/bin/bash'

  $user = 'rundeck'
  $group = 'rundeck'

  $loglevel = 'INFO'
  $rss_enabled = false

  $grails_server_url = "http://${::fqdn}:4440"
  $dataSource_dbCreate = 'update'
  $dataSource_url = 'jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true'

  $keystore = '/etc/rundeck/ssl/keystore'
  $keystore_password = 'adminadmin'
  $key_password = 'adminadmin'
  $truststore = '/etc/rundeck/ssl/truststore'
  $truststore_password = 'adminadmin'

  $resource_sources = {}

  $jvm_args = '-Xmx1024m -Xms256m -server'

  $ssl_enabled = false
  $ssl_port = '4443'

  $package_source = 'http://dl.bintray.com/rundeck/rundeck-deb'
}
