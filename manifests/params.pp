# == Class rundeck::params
#
# This class is meant to be called from rundeck
# It sets variables according to platform
#
class rundeck::params {

  case $::osfamily {
    'Debian': {
      $package_name = 'rundeck'
      $package_version = '2.0.3-1-GA'
      $service_name = 'rundeckd'
      $jre_name = 'openjdk-6-jre'
      $jre_version = '6b30-1.13.1-1ubuntu2~0.12.04.1'
    }
    'RedHat', 'Amazon': {
      $package_name = 'rundeck'
      $package_version = '2.0.3-1.14.GA'
      $service_name = 'rundeckd'
      $jre_name = 'java-1.6.0-openjdk'
      $jre_version = '1.6.0.0-1.66.1.13.0.el6'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }


  $rdeck_base = '/var/lib/rundeck'
  $projects_dir = '/var/rundeck/projects'
  $properties_dir = '/etc/rundeck'
  $plugin_dir = "${rdeck_base}/libext"
  $logs_dir = "${rdeck_base}/logs"
  $tmp_dir = "${rdeck_base}/var/tmp"
  $var_dir = "${rdeck_base}/var"
  $log_dir = '/var/log/rundeck'

  $ssh_keypath = "${rdeck_base}/.ssh/id_rsa"
  $ssh_timeout = 0
  $ssh_user = 'rundeck'

  $auth_type = 'file'
  $auth_users = {}

  $server_name = 'localhost'
  $server_hostname = 'localhost'
  $server_port = '4440'
  $server_url = 'http://localhost:4440'
  $cli_username = 'admin'
  $cli_password = 'admin'

  $admin_user = 'admin'
  $admin_password = 'admin'

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

  $grails_server_url = 'http://localhost:4440'
  $dataSource_dbCreate = 'update'
  $dataSource_url = "jdbc:h2:file:${rdeck_base}/data/rundeckdb;MVCC=true"

  $keystore = "${properties_dir}/ssl/keystore"
  $keystore_password = 'adminadmin'
  $key_password = 'adminadmin'
  $truststore = "${properties_dir}/ssl/truststore"
  $truststore_password = 'adminadmin'

  $resource_sources = {}

  $jvm_args = '-Xmx1024m -Xms256m -server'

  $ssl_enabled = false
  $ssl_port = '4443'

  $package_sourcetype = 'custom'
  $package_sourcerepo = 'http://dl.bintray.com/rundeck/rundeck-deb'
}
