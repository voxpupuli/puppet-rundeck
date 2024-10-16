# @summary Class to manage installation and configuration of Rundeck.
#
# @param override_dir
#   An absolute path to the overrides directory.
#   Examples/defaults for yumrepo can be found at RedHat.yaml, and for apt at Debian.yaml
# @param repo_config
#   A hash of repository attributes for configuring the rundeck package repositories.
#   Examples/defaults for yumrepo can be found at RedHat.yaml, and for apt at Debian.yaml
# @param manage_repo
#   Whether to manage the package repository.
# @param package_ensure
#   Ensure the state of the rundeck package, either present, absent or a specific version.
# @param manage_home
#   Whether to manage rundeck home dir.
# @param user
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param manage_user
#   Whether to manage `user` (and enforce `user_id` if set).
# @param manage_group
#   Whether to manage `group` (and enforce `group_id` if set).
# @param user_id
#   If you want to have always the same user id. Eg. because of a NFS share.
# @param group_id
#   If you want to have always the same group id. Eg. because of a NFS share.
# @param admin_policies
#   Admin acl policies.
# @param api_policies
#   Apitoken acl policies.
# @param manage_default_admin_policy
#   Whether to manage the default admin policy.
# @param manage_default_api_policy
#   Whether to manage default api policy.
# @param grails_server_url
#   Sets `grails.serverURL` so that Rundeck knows its external address.
# @param clustermode_enabled
#   Wheter to enable cluster mode.
# @param execution_mode
#   Set the execution mode to 'active' or 'passive'.
# @param api_token_max_duration
#   Set the token max duration.
# @param java_home
#   Set the home directory of java.
# @param jvm_args
#   Extra arguments for the JVM.
# @param quartz_job_threadcount
#   The maximum number of threads used by Rundeck for concurrent jobs.
# @param auth_config
#   Hash of properties for configuring [Rundeck JAAS Authentication](https://docs.rundeck.com/docs/administration/security/authentication.html#jetty-and-jaas-authentication)
# @param database_config
#   Hash of properties for configuring the [Rundeck Database](https://docs.rundeck.com/docs/administration/configuration/database)
# @param feature_config
#   A hash of rundeck features.
# @param framework_config
#   Hash of properties for configuring the [Rundeck Framework](https://docs.rundeck.com/docs/administration/configuration/config-file-reference.html#framework-properties)
#   This hash will be merged with the [Rundeck defaults](https://github.com/voxpupuli/puppet-rundeck/blob/master/manifests/config.pp#L8-L20)
# @param grails_config
#   A hash of the rundeck grails configuration.
# @param gui_config
#   Hash of properties for customizing the [Rundeck GUI](https://docs.rundeck.com/docs/administration/configuration/gui-customization.html)
# @param mail_config
#   A hash of the notification email configuraton.
# @param security_config
#   A hash of the rundeck security configuration.
# @param preauthenticated_config
#   A hash of the rundeck preauthenticated configuration.
# @param key_storage_config
#   An array with hashes of properties for customizing the [Rundeck Key Storage](https://docs.rundeck.com/docs/manual/key-storage/key-storage.html)
# @param key_storage_encrypt_config
#   An array with hashes of properties for customizing the [Rundeck Key Storage converter](https://docs.rundeck.com/docs/administration/configuration/plugins/configuring.html#storage-converter-plugins)
# @param root_log_level
#   The log4j root logging level to be set for Rundeck.
# @param app_log_level
#   The log4j logging level to be set for the Rundeck application.
# @param audit_log_level
#   The log4j logging level to be set for the Rundeck autorization.
# @param webhook_plugins_log_level
#   The log4j logging level to be set for the Rundeck plugin webhooks.
# @param execution_cleanup_log_level
#   The log4j logging level to be set for the Rundeck execution cleanup.
# @param jaas_log_level
#   The log4j logging level to be set for the Rundeck jaas security.
# @param config_template
#   The template used for rundeck-config properties. Needs to be in epp format.
# @param override_template
#   The template used for rundeck profile overrides. Needs to be in epp format.
# @param realm_template
#   The template used for jaas realm properties. Needs to be in epp format.
# @param log_properties_template
#   The template used for log properties. Needs to be in epp format.
# @param rss_enabled
#   Boolean value if set to true enables RSS feeds that are public (non-authenticated)
# @param server_web_context
#   Web context path to use, such as "/rundeck". http://host.domain:port/server_web_context
# @param ssl_enabled
#   Enable ssl for the rundeck web application.
# @param ssl_port
#   Ssl port of the rundeck web application.
# @param ssl_certificate
#   Full path to the SSL public key to be used by Rundeck.
# @param ssl_private_key
#   Full path to the SSL private key to be used by Rundeck.
# @param key_password
#   The password used to protect the key in keystore.
# @param keystore
#   Full path to the java keystore to be used by Rundeck.
# @param keystore_password
#   The password for the given keystore.
# @param truststore
#   The full path to the java truststore to be used by Rundeck.
# @param truststore_password
#   The password for the given truststore.
# @param service_name
#   The name of the rundeck service.
# @param service_ensure
#   State of the rundeck service.
# @param service_logs_dir
#   The path to the directory to store service related logs.
# @param service_notify
#   Wheter to notify and restart the rundeck service if config changes.
# @param service_config
#   Allows you to use your own override template instead to config rundeckd init script.
# @param service_script
#   Allows you to use your own override template instead of the default from the package maintainer for rundeckd init script.
# @param manage_cli
#   Whether to manage rundeck cli config and resource with the rundeck class or not.
# @param cli_version
#   Ensure the state of the rundeck cli package, either present, absent or a specific version.
# @param cli_user
#   Cli user to authenticate.
# @param cli_password
#   Cli password to authenticate.
# @param cli_token
#   Cli token to authenticate.
# @param cli_projects
#   Cli projects config.
#
class rundeck (
  Stdlib::Absolutepath $override_dir,
  Hash $repo_config,
  Boolean $manage_repo = true,
  String[1] $package_ensure = 'installed',
  Boolean $manage_home = true,
  String[1] $user = 'rundeck',
  String[1] $group = 'rundeck',
  Boolean $manage_user = false,
  Boolean $manage_group = false,
  Optional[Integer] $user_id = undef,
  Optional[Integer] $group_id = undef,
  Array[Hash] $admin_policies = [
    {
      'description' => 'Admin, all access',
      'context'     => { 'project' => '.*' },
      'for'         => {
        'resource' => [{ 'allow' => '*' }],
        'adhoc'    => [{ 'allow' => '*' }],
        'job'      => [{ 'allow' => '*' }],
        'node'     => [{ 'allow' => '*' }],
      },
      'by'          => [{ 'group' => ['admin'] }],
    },
    {
      'description' => 'Admin, all access',
      'context'     => { 'application' => 'rundeck' },
      'for'         => {
        'project'  => [{ 'allow' => '*' }],
        'resource' => [{ 'allow' => '*' }],
        'storage'  => [{ 'allow' => '*' }],
      },
      'by'          => [{ 'group' => ['admin'] }],
    },
  ],
  Array[Hash] $api_policies = [
    {
      'description' => 'API project level access control',
      'context'     => { 'project' => '.*' },
      'for'         => {
        'resource' => [
          { 'equals' => { 'kind' => 'job' }, 'allow' => ['create', 'delete'] },
          { 'equals' => { 'kind' => 'node' }, 'allow' => ['read', 'create', 'update', 'refresh'] },
          { 'equals' => { 'kind' => 'event' }, 'allow' => ['read', 'create'] },
        ],
        'adhoc'    => [{ 'allow' => ['read', 'run', 'kill'] }],
        'job'      => [{ 'allow' => ['read', 'create', 'update', 'delete', 'run', 'kill'] }],
        'node'     => [{ 'allow' => ['read', 'run'] }],
      },
      'by'          => [{ 'group' => ['api_token_group'] }],
    },
    {
      'description' => 'API Application level access control',
      'context'     => { 'application' => 'rundeck' },
      'for'         => {
        'project'  => [{ 'match' => { 'name' => '.*' }, 'allow' => ['read'] }],
        'resource' => [{ 'equals' => { 'kind' => 'system' }, 'allow' => ['read'] }],
        'storage'  => [{ 'match' => { 'path' => '(keys|keys/.*)' }, 'allow' => '*' }],
      },
      'by'          => [{ 'group' => ['api_token_group'] }],
    },
  ],
  Boolean $manage_default_admin_policy = true,
  Boolean $manage_default_api_policy = true,
  Stdlib::HTTPUrl $grails_server_url = "http://${facts['networking']['fqdn']}:4440",
  Boolean $clustermode_enabled = false,
  Enum['active', 'passive'] $execution_mode = 'active',
  String[1] $api_token_max_duration = '30d',
  Optional[Stdlib::Absolutepath] $java_home = undef,
  String $jvm_args = '-Xmx1024m -Xms256m -server',
  Integer $quartz_job_threadcount = 10,
  Rundeck::Auth_config $auth_config = {
    'file' => {
      'auth_flag'    => 'required',
      'jaas_config'  => {
        'file' => '/etc/rundeck/realm.properties',
      },
      'realm_config' => {
        'admin_user'     => 'admin',
        'admin_password' => 'admin',
        'auth_users'     => [],
      },
    },
  },
  Rundeck::Db_config $database_config = { 'url' => 'jdbc:h2:file:/var/lib/rundeck/data/rundeckdb' },
  Hash $feature_config = {},
  Hash $framework_config = {},
  Hash $grails_config = {},
  Hash $gui_config = {},
  Rundeck::Mail_config $mail_config = {},
  Hash $security_config = {},
  Hash $preauthenticated_config = {},
  Rundeck::Key_storage_config $key_storage_config = [{ 'type' => 'db', 'path' => 'keys' }],
  Array[Hash] $key_storage_encrypt_config = [],
  Rundeck::Loglevel $root_log_level = 'info',
  Rundeck::Loglevel $app_log_level = 'info',
  Rundeck::Loglevel $audit_log_level = 'info',
  Rundeck::Loglevel $webhook_plugins_log_level = 'info',
  Rundeck::Loglevel $execution_cleanup_log_level = 'info',
  Rundeck::Loglevel $jaas_log_level = 'info',
  String[1] $config_template = 'rundeck/rundeck-config.properties.epp',
  String[1] $override_template = 'rundeck/profile_overrides.epp',
  String[1] $realm_template = 'rundeck/realm.properties.epp',
  String[1] $log_properties_template = 'rundeck/log4j2.properties.epp',
  Boolean $rss_enabled = false,
  Optional[String[1]] $server_web_context = undef,
  Boolean $ssl_enabled = false,
  Stdlib::Port $ssl_port = 4443,
  Stdlib::Absolutepath $ssl_certificate = '/etc/rundeck/ssl/rundeck.crt',
  Stdlib::Absolutepath $ssl_private_key = '/etc/rundeck/ssl/rundeck.key',
  Optional[String[1]] $key_password = undef,
  Stdlib::Absolutepath $keystore = '/etc/rundeck/ssl/keystore',
  String[1] $keystore_password = 'adminadmin',
  Stdlib::Absolutepath $truststore = '/etc/rundeck/ssl/truststore',
  String[1] $truststore_password = 'adminadmin',
  String[1] $service_name = 'rundeckd',
  Enum['stopped', 'running'] $service_ensure = 'running',
  Stdlib::Absolutepath $service_logs_dir = '/var/log/rundeck',
  Boolean $service_notify = true,
  Optional[String[1]] $service_config = undef,
  Optional[String[1]] $service_script = undef,
  Boolean $manage_cli = true,
  String[1] $cli_version = 'installed',
  String[1] $cli_user = 'admin',
  String[1] $cli_password = 'admin',
  Optional[String[8]] $cli_token = undef,
  Hash[String, Rundeck::Project] $cli_projects = {},
) {
  validate_rd_policy($admin_policies)
  validate_rd_policy($api_policies)

  contain rundeck::install
  contain rundeck::config
  contain rundeck::service

  if $service_notify {
    Class['rundeck::install']
    -> Class['rundeck::config']
    ~> Class['rundeck::service']
  } else {
    Class['rundeck::install']
    -> Class['rundeck::config']
    -> Class['rundeck::service']
  }

  if $manage_cli {
    class { 'rundeck::cli':
      manage_repo       => false,
      notify_conn_check => true,
      version           => $cli_version,
      url               => $rundeck::config::framework_config['framework.server.url'],
      bypass_url        => $grails_server_url,
      user              => $cli_user,
      password          => $cli_password,
      token             => $cli_token,
      projects          => $cli_projects,
    }

    Class['rundeck::service']
    -> Class['rundeck::cli']
  }
}
