# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class rundeck::params
#
# This class is meant to be called from `rundeck`
# It sets variables according to platform
#
class rundeck::params {
  $package_name = 'rundeck'
  $package_ensure = 'installed'
  $service_name = 'rundeckd'
  $manage_repo = true
  $repo_yum_source = 'http://dl.bintray.com/rundeck/rundeck-rpm/'
  $repo_yum_gpgkey = 'https://bintray.com/user/downloadSubjectPublicKey?username=rundeck'
  $repo_apt_source = 'https://dl.bintray.com/rundeck/rundeck-deb'
  $repo_apt_key_id = '8756C4F765C9AC3CB6B85D62379CE192D401AB61'
  $repo_apt_keyserver = 'keyserver.ubuntu.com'

  case $facts['osfamily'] {
    'Debian': {
      $overrides_dir = '/etc/default'
    }
    'RedHat', 'Amazon': {
      $overrides_dir = '/etc/sysconfig'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $service_manage = false
  $service_ensure = 'running'

  $rdeck_base = '/var/lib/rundeck'
  $rdeck_home = '/var/lib/rundeck'
  $manage_home = true
  $service_logs_dir = '/var/log/rundeck'

  $framework_config = {
    'framework.server.name'     => $facts['fqdn'],
    'framework.server.hostname' => $facts['fqdn'],
    'framework.server.port'     => '4440',
    'framework.server.url'      => "http://${facts['fqdn']}:4440",
    'framework.server.username' => 'admin',
    'framework.server.password' => 'admin',
    'rdeck.base'                => '/var/lib/rundeck',
    'framework.projects.dir'    => '/var/lib/rundeck/projects',
    'framework.etc.dir'         => '/etc/rundeck',
    'framework.var.dir'         => '/var/lib/rundeck/var',
    'framework.tmp.dir'         => '/var/lib/rundeck/var/tmp',
    'framework.logs.dir'        => '/var/lib/rundeck/logs',
    'framework.libext.dir'      => '/var/lib/rundeck/libext',
    'framework.ssh.keypath'     => '/var/lib/rundeck/.ssh/id_rsa',
    'framework.ssh.user'        => 'rundeck',
    'framework.ssh.timeout'     => '0',
    'rundeck.server.uuid'       => fqdn_uuid($facts['fqdn']),
  }

  $auth_types = ['file']
  $auth_users = {}
  $auth_template = 'rundeck/jaas-auth.conf.erb'

  $log_properties_template = 'rundeck/log4j.properties.erb'

  $acl_template = 'rundeck/aclpolicy.erb'
  $api_template = 'rundeck/aclpolicy.erb'

  $acl_policies = [
    {
      'description' => 'Admin, all access',
      'context' => {
        'project' => '.*',
      },
      'for' => {
        'resource' => [
          {'allow' => '*'},
        ],
        'adhoc' => [
          {'allow' => '*'},
        ],
        'job' => [
          {'allow' => '*'},
        ],
        'node' => [
          {'allow' => '*'},
        ],
      },
      'by' => [{
        'group' => ['admin']
      }]
    },
    {
      'description' => 'Admin, all access',
      'context' => {
        'application' => 'rundeck',
      },
      'for' => {
        'resource' => [
          {'allow' => '*'},
        ],
        'project' => [
          {'allow' => '*'},
        ],
        'storage' => [
          {'allow' => '*'},
        ],
      },
      'by' => [{
        'group' => ['admin']
      }]
    }
  ]

  $api_policies = [
    {
      'description' => 'API project level access control',
      'context' => {
        'project' => '.*',
      },
      'for' => {
        'resource' => [
          { 'equals' => {'kind' => 'job'}, 'allow' => ['create','delete'] },
          { 'equals' => {'kind' => 'node'}, 'allow' => ['read','create','update','refresh'] },
          { 'equals' => {'kind' => 'event'}, 'allow' => ['read','create'] }
        ],
        'adhoc' => [
          {'allow' => ['read','run','kill']}
        ],
        'job' => [
          {'allow' => ['create','read','update','delete','run','kill']}
        ],
        'node' => [
          {'allow' => ['read','run']}
        ],
      },
      'by' => [{
        'group' => ['api_token_group']
      }]
    },
    {
      'description' => 'API Application level access control',
      'context' => {
        'application' => 'rundeck',
      },
      'for' => {
        'resource' => [
          { 'equals' => {'kind' => 'system'}, 'allow' => ['read'] }
        ],
        'project' => [
          { 'match' => {'name' => '.*'}, 'allow' => ['read'] }
        ],
        'storage' => [
          { 'match' => {'path' => '(keys|keys/.*)'}, 'allow' => '*' },
        ],
      },
      'by' => [{
        'group' => ['api_token_group']
      }]
    }
  ]

  $auth_config = {
    'file' => {
      'admin_user'     => $framework_config['framework.server.username'],
      'admin_password' => $framework_config['framework.server.password'],
      'auth_users'     => {},
      'file'           => '/etc/rundeck/realm.properties',
    },
    'pam' => {
      'service'            => 'sshd',
      'supplemental_roles' => ['user'],
      'store_pass'         => true,
      'clear_pass'         => undef,
      'try_first_pass'     => undef,
      'use_first_pass'     => undef,
      'use_unix_groups'    => undef,
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
      'role_prefix'             => undef,
      'nested_groups'           => true,
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
      'role_prefix'             => undef,
      'supplemental_roles'      => 'user',
      'nested_groups'           => true,
    },
  }

  $realm_template = 'rundeck/realm.properties.erb'

  $mail_config = {}

  $security_config = {
    'useHMacRequestTokens' => true,
    'apiCookieAccess'      => true,
  }

  $projects = {}
  $projects_default_org = ''
  $projects_default_desc = ''

  $file_copier_provider = 'jsch-scp'
  $node_executor_provider = 'jsch-ssh'

  $url_cache = true
  $url_timeout = 30

  $resource_format = 'resourcexml'
  $include_server_node = false
  $default_source_type = 'file'
  $default_resource_dir = '/'
  $default_http_proxy_port = 80
  $default_refresh_interval = 30

  $script_args_quoted = true
  $script_interpreter = '/bin/bash'

  $manage_user = false
  $manage_group = false

  $user = 'rundeck'
  $group = 'rundeck'
  $file_default_mode = '0640'

  $loglevel = 'INFO'
  $rss_enabled = false

  $clustermode_enabled = false

  $grails_server_url = "http://${facts['fqdn']}:4440"

  $database_config = {
    'type'            => 'h2',
    'dbCreate'        => 'update',
    'url'             => 'jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true',
    'driverClassName' => '',
    'username'        => '',
    'password'        => '',
    'dialect'         => '',
    'enable_h2_logs'  => 'on',
  }

  $kerberos_realms = {}

  $keystore = '/etc/rundeck/ssl/keystore'
  $key_storage_type = 'file'
  $projects_storage_type = 'filesystem'
  $keystore_password = 'adminadmin'
  $key_password = 'adminadmin'
  $truststore = '/etc/rundeck/ssl/truststore'
  $truststore_password = 'adminadmin'

  $resource_sources = {}
  $gui_config = {}

  $preauthenticated_config = {
    'enabled'         => false,
    'attributeName'   => 'REMOTE_USER_GROUPS',
    'delimiter'       => ':',
    'userNameHeader'  => 'X-Forwarded-Uuid',
    'userRolesHeader' => 'X-Forwarded-Roles',
    'redirectLogout'  => false,
    'redirectUrl'     => '/oauth2/sign_in',
  }

  $quartz_job_threadcount = 10

  $jvm_args = '-Xmx1024m -Xms256m -server'

  $sshkey_manage = true

  $ssl_enabled = false
  $ssl_port = 4443

  $ssl_keyfile = '/etc/rundeck/ssl/rundeck.key'
  $ssl_certfile = '/etc/rundeck/ssl/rundeck.crt'

  $web_xml = "${rdeck_base}/exp/webapp/WEB-INF/web.xml"
  $security_role = 'user'
  $session_timeout = 30

  $rdeck_config_template = 'rundeck/rundeck-config.erb'

  $file_keystorage_keys = { }
  $file_keystorage_dir = "${framework_config['framework.var.dir']}/storage"

  $manage_default_admin_policy = true
  $manage_default_api_policy   = true

  $security_roles_array_enabled = false
  $security_roles_array         = []

}
