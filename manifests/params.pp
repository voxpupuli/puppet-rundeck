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
      $package_ensure = '2.5.0-1-GA'
      $service_name = 'rundeckd'
      $jre_name = ''
      $jre_ensure = 'installed'
      $manage_yum_repo = false
    }
    'RedHat', 'Amazon': {
      $package_name = 'rundeck'
      $package_ensure = 'installed'
      $service_name = 'rundeckd'
      $jre_name = ''
      $jre_ensure = 'installed'
      $manage_yum_repo = true
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $jre_manage = true

  $service_manage = false
  $service_config = ''
  $service_script = ''

  $rdeck_base = '/var/lib/rundeck'
  $rdeck_home = '/var/rundeck'
  $service_logs_dir = '/var/log/rundeck'

  $framework_config = {
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
    'framework.ssh.timeout'     => '0',
    'rundeck.server.uuid'       => $::serialnumber,
  }

  $auth_types = ['file']
  $auth_users = {}
  $auth_template = 'rundeck/jaas-auth.conf.erb'

  $acl_template = 'rundeck/admin.aclpolicy.erb'
  $api_template = 'rundeck/apitoken.aclpolicy.erb'

  $acl_policies = [
    {
      'description' => 'Admin, all access',
      'context' => {
        'type' => 'project',
        'rule' => '.*'
      },
      'resource_types' => [
        { 'type'  => 'resource', 'rules' => [{'name' => 'allow','rule' => '*'}] },
        { 'type'  => 'adhoc', 'rules' => [{'name' => 'allow','rule' => '*'}] },
        { 'type'  => 'job', 'rules' => [{'name' => 'allow','rule' => '*'}] },
        { 'type'  => 'node', 'rules' => [{'name' => 'allow','rule' => '*'}] }
      ],
      'by' => {
        'groups'    => ['admin'],
        'usernames' => undef
      }
    },
    {
      'description' => 'Admin, all access',
      'context' => {
        'type' => 'application',
        'rule' => 'rundeck'
      },
      'resource_types' => [
        { 'type'  => 'resource', 'rules' => [{'name' => 'allow','rule' => '*'}] },
        { 'type'  => 'project', 'rules' => [{'name' => 'allow','rule' => '*'}] },
      ],
      'by' => {
        'groups'    => ['admin'],
        'usernames' => undef
      }
    }
  ]

  $api_policies = [
  {
    'description' => 'API project level access control',
    'context' => {
      'type' => 'project',
      'rule' => '.*'
    },
    'resource_types' => [
      {
        'type'  => 'resource', 'rules' => [
          { 'filter' => { 'filter_type' => 'equals', 'filter_property' => 'kind', 'filter_value' => 'job' },
            'name' => 'allow',
            'rule' => ['create','delete']
          },
          { 'filter' => { 'filter_type' => 'equals', 'filter_property' => 'kind', 'filter_value' => 'node' },
            'name' => 'allow',
            'rule' => ['read','create','update','refresh']
          },
          { 'filter' => { 'filter_type' => 'equals', 'filter_property' => 'kind', 'filter_value' => 'event' },
            'name' => 'allow',
            'rule' => ['read','create']
          }
        ]
      },
      { 'type'  => 'adhoc', 'rules' => [{'name' => 'allow','rule' => ['read','run','kill']}] },
      { 'type'  => 'job', 'rules' => [{'name' => 'allow','rule' => ['create','read','update','delete','run','kill']}] },
      { 'type'  => 'node', 'rules' => [{'name' => 'allow','rule' => ['read','run']}] }
    ],
    'by' => {
      'groups'    => ['api_token_group'],
      'usernames' => undef
    }
  },
  {
    'description' => 'API Application level access control',
    'context' => {
      'type' => 'application',
      'rule' => 'rundeck'
    },
    'resource_types' => [
      {
        'type'  => 'resource', 'rules' => [
          { 'filter' => { 'filter_type' => 'equals', 'filter_property' => 'kind', 'filter_value' => 'system' },
            'name' => 'allow',
            'rule' => ['read']
          }
        ]
      },
      {
        'type'  => 'project', 'rules' => [
          { 'filter' => { 'filter_type' => 'match', 'filter_property' => 'name', 'filter_value' => '.*' },
            'name' => 'allow',
            'rule' => ['read']
          }
        ]
      },
      { 'type'  => 'storage', 'rules' => [
          { 'filter' => { 'filter_type' => 'match', 'filter_property' => 'path', 'filter_value' => '(keys|keys/.*)' },
            'name' => 'allow',
            'rule' => '*'
          }
        ]
      }
    ],
    'by' => {
      'groups'    => ['api_token_group'],
      'usernames' => undef
    }
  }
  ]

  $auth_config = {
    'file' => {
      'admin_user'     => $framework_config['framework.server.username'],
      'admin_password' => $framework_config['framework.server.password'],
      'auth_users'     => {},
      'file'           => '/etc/rundeck/realm.properties'
    },
    'ldap' => {
      'server'                  => undef,
      'port'                    => '389',
      'force_binding'           => false,
      'force_binding_use_root'  => false,
      'bind_dn'                 => undef,
      'bind_password'           => undef,
      'user_base_dn'            => undef,
      'user_rdn_attribute'      => 'uid',
      'user_id_attribute'       => 'uid',
      'user_password_attribute' => 'userPassword',
      'user_object_class'       => 'user',
      'role_base_dn'            => undef,
      'role_name_attribute'     => 'cn',
      'role_member_attribute'   => 'memberUid',
      'role_object_class'       => 'group',
      'nested_groups'           => true
    },
    'active_directory' => {
      'server'                  => undef,
      'port'                    => '389',
      'force_binding'           => true,
      'force_binding_use_root'  => true,
      'bind_dn'                 => undef,
      'bind_password'           => undef,
      'user_base_dn'            => undef,
      'user_rdn_attribute'      => 'sAMAccountName',
      'user_id_attribute'       => 'sAMAccountName',
      'user_password_attribute' => 'unicodePwd',
      'user_object_class'       => 'user',
      'role_base_dn'            => undef,
      'role_name_attribute'     => 'cn',
      'role_member_attribute'   => 'member',
      'role_object_class'       => 'group',
      'supplemental_roles'      => 'user',
      'nested_groups'           => true
    }
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

  $clustermode_enabled = false

  $grails_server_url = "http://${::fqdn}:4440"

  $database_config = {
    'type'            => 'h2',
    'dbCreate'        => 'update',
    'url'             => 'jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true',
    'driverClassName' => '',
    'username'        => '',
    'password'        => '',
    'dialect'         => ''
  }

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
