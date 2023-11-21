# @summary Class to manage installation and configuration of Rundeck.
#
# @param acl_template
#   The template used for acl policy. Needs to be in epp format.
# @param admin_policies
#   Admin acl policies. Default value is located in data/common.yaml.
# @param api_policies
#   Apitoken acl policies. Default value is located in data/common.yaml.
# @param auth_config
#   Hash of properties for configuring [Rundeck JAAS Authentication](https://docs.rundeck.com/docs/administration/security/authentication.html#jetty-and-jaas-authentication)
#   Default value is located in data/common.yaml.
# @param clustermode_enabled
#   Boolean value if set to true enables cluster mode
# @param database_config
#   Hash of properties for configuring the [Rundeck Database](https://docs.rundeck.com/docs/administration/configuration/database)
# @param execution_mode
#   If set, allows setting the execution mode to 'active' or 'passive'.
# @param file_keystorage_dir
#   Path to dir where the keystorage should be located.
# @param file_keystorage_keys
#   Add keys to file keystorage.
# @param framework_config
#   Hash of properties for configuring the [Rundeck Framework](https://docs.rundeck.com/docs/administration/configuration/config-file-reference.html#framework-properties)
#   Default value is located in data/common.yaml.
# @param grails_server_url
#   Sets `grails.serverURL` so that Rundeck knows its external address.
# @param gui_config
#   Hash of properties for customizing the [Rundeck GUI](https://docs.rundeck.com/docs/administration/configuration/gui-customization.html)
# @param java_home
#   Set the home directory of java.
# @param jvm_args
#   Extra arguments for the JVM.
# @param kerberos_realms
#   A hash of mappings between Kerberos domain DNS names and realm names
# @param key_storage_config
#   An array with hashes of properties for customizing the [Rundeck Key Storage](https://docs.rundeck.com/docs/manual/key-storage/key-storage.html)
# @param keystore
#   Full path to the java keystore to be used by Rundeck.
# @param keystore_password
#   The password for the given keystore.
# @param log_properties_template
#   The template used for log properties. Needs to be in epp format.
# @param mail_config
#   A hash of the notification email configuraton.
# @param key_password
#   The ssl key password.
# @param ssl_keyfile
#   Full path to the SSL private key to be used by Rundeck.
# @param ssl_certfile
#   Full path to the SSL public key to be used by Rundeck.
# @param manage_default_admin_policy
#   Boolean value if set to true enables default admin policy management
# @param manage_default_api_policy
#   Boolean value if set to true enables default api policy management
# @param repo_config
#   A hash of repository types and attributes for configuring the rundeck package repositories.
#   Examples/defaults for yumrepo can be found at data/os/RedHat.yaml, and for apt at data/os/Debian.yaml
# @param manage_repo
#   Whether to manage the package repository. Defaults to true.
# @param package_ensure
#   Ensure the state of the rundeck package, either present, absent or a specific version
# @param preauthenticated_config
#   A hash of the rundeck preauthenticated config mode
# @param projects
#   The hash of projects in your instance.
# @param projects_description
#   The description that will be set by default for any projects.
# @param projects_organization
#   The organization value that will be set by default for any projects.
# @param quartz_job_threadcount
#   The maximum number of threads used by Rundeck for concurrent jobs by default is set to 10.
# @param app_log_level
#   The log4j logging level to be set for the Rundeck application.
# @param audit_log_level
#   The log4j logging level to be set for the Rundeck autorization.
# @param config_template
#   Allows you to override the rundeck-config template.
# @param manage_home
#   Whether to manage rundeck home dir. Defaults to true.
# @param override_template
#   Allows you to use your own override template for rundeck profile instead of the default from the package maintainer
# @param realm_template
#   Allows you to use your own override template for realm properties instead of the default from the package maintainer
# @param rss_enabled
#   Boolean value if set to true enables RSS feeds that are public (non-authenticated)
# @param security_config
#   A hash of the rundeck security configuration.
# @param security_role
#   Name of the role that is required for all users to be allowed access.
# @param server_web_context
#   Web context path to use, such as "/rundeck". http://host.domain:port/server_web_context
# @param service_name
#   The name of the rundeck service.
# @param service_ensure
#   State of the rundeck service (defaults to 'running')
# @param service_restart
#   The restart of the rundeck service (default to true)
# @param service_logs_dir
#   The path to the directory to store service related logs.
# @param service_config
#   Allows you to use your own override template instead to config rundeckd init script.
# @param service_script
#   Allows you to use your own override template instead of the default from the package maintainer for rundeckd init script.
# @param session_timeout
#   Session timeout is an expired time limit for a logged in Rundeck GUI user which as been inactive for a period of time.
# @param ssl_enabled
#   Enable ssl for the rundeck web application.
# @param ssl_port
#   Ssl port of the rundeck web application (default to '4443').
# @param truststore
#   The full path to the java truststore to be used by Rundeck.
# @param truststore_password
#   The password for the given truststore.
# @param user
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param manage_user
#   Whether to manage `user` (and enforce `user_id` if set). Defaults to false.
# @param manage_group
#   Whether to manage `group` (and enforce `group_id` if set). Defaults to false.
# @param user_id
#   If you want to have always the same user id. Eg. because of the NFS share.
# @param group_id
#   If you want to have always the same group id. Eg. because of the NFS share.
# @param security_roles_array_enabled
#   Boolean value if you need more roles. false or true (default is false).
# @param security_roles_array
#   Array value if you need more roles and you set true the "security_roles_array_enabled" value.
# @param storage_encrypt_config
#   Hash containing the necessary values to configure a plugin for key storage encryption.
#   https://docs.rundeck.com/docs/administration/configuration/plugins/configuring.html#storage-converter-plugins
#
class rundeck (
  Array[Hash]                         $admin_policies,
  Array[Hash]                         $api_policies,
  Rundeck::Authconfig                 $auth_config,
  Hash                                $framework_config,
  Hash                                $project_config,
  Hash                                $database_config,
  Array[Hash]                         $key_storage_config,
  Hash                                $security_config,
  Hash                                $preauthenticated_config,
  String                              $keystore_password,
  String                              $truststore_password,
  Stdlib::Absolutepath                $file_keystorage_dir,
  Stdlib::Absolutepath                $override_dir,
  Hash                                $repo_config,
  Boolean                             $manage_repo                        = true,
  String                              $package_ensure                     = 'installed',

  Boolean                             $clustermode_enabled                = false,
  Enum['active', 'passive']           $execution_mode                     = 'active',
  Hash                                $file_keystorage_keys               = {},
  Stdlib::HTTPUrl                     $grails_server_url                  = "http://${facts['networking']['fqdn']}:4440",
  Hash                                $gui_config                         = {},
  Optional[Stdlib::Absolutepath]      $java_home                          = undef,
  String                              $jvm_args                           = '-Xmx1024m -Xms256m -server',
  Optional[Hash]                      $kerberos_realms                    = undef,
  Stdlib::Absolutepath                $keystore                           = '/etc/rundeck/ssl/keystore',
  Hash                                $mail_config                        = {},
  Boolean                             $manage_default_admin_policy        = true,
  Boolean                             $manage_default_api_policy          = true,
  # Log config
  Rundeck::Loglevel                   $app_log_level                      = 'info',
  Rundeck::Loglevel                   $audit_log_level                    = 'info',
  # Template config
  String                              $config_template                    = 'rundeck/rundeck-config.epp',
  String                              $override_template                  = 'rundeck/profile_overrides.epp',
  String                              $realm_template                     = 'rundeck/realm.properties.epp',
  String                              $acl_template                       = 'rundeck/aclpolicy.erb',
  String                              $log_properties_template            = 'rundeck/log4j2.properties.epp',

  Boolean                             $rss_enabled                        = false,
  String                              $security_role                      = 'user',
  Optional[String]                    $server_web_context                 = undef,
  Integer                             $session_timeout                    = 30,
  Boolean                             $ssl_enabled                        = false,
  Stdlib::Port                        $ssl_port                           = 4443,
  Optional[String]                    $key_password                       = undef,
  Stdlib::Absolutepath                $ssl_keyfile                        = '/etc/rundeck/ssl/rundeck.key',
  Stdlib::Absolutepath                $ssl_certfile                       = '/etc/rundeck/ssl/rundeck.crt',
  Stdlib::Absolutepath                $truststore                         = '/etc/rundeck/ssl/truststore',
  Boolean                             $security_roles_array_enabled       = false,
  Array                               $security_roles_array               = [],
  Hash[String,String]                 $storage_encrypt_config             = {},
  # User config
  String                              $user                               = 'rundeck',
  String                              $group                              = 'rundeck',
  Boolean                             $manage_user                        = false,
  Boolean                             $manage_group                       = false,
  Optional[Integer]                   $user_id                            = undef,
  Optional[Integer]                   $group_id                           = undef,
  # Service config
  String                              $service_name                       = 'rundeckd',
  Enum['stopped', 'running']          $service_ensure                     = 'running',
  Boolean                             $service_restart                    = true,
  Stdlib::Absolutepath                $service_logs_dir                   = '/var/log/rundeck',
  Optional[String]                    $service_config                     = undef,
  Optional[String]                    $service_script                     = undef,
  # Project config
  Hash                                $projects                           = {},

  Integer                             $quartz_job_threadcount             = 10,
  String                              $file_copier_provider               = 'jsch-scp',
  String                              $node_executor_provider             = 'jsch-ssh',
  Hash                                $resource_sources                   = {},
  Enum['xml', 'yaml']                 $resource_format                    = 'xml',
  Boolean                             $include_server_node                = false,
  Enum['file']                        $default_source_type                = 'file',
  Stdlib::Absolutepath                $default_resource_dir               = '/',
  Stdlib::Port                        $default_http_proxy_port            = 80,
  Integer                             $default_refresh_interval           = 30,
  Boolean                             $url_cache                          = true,
  Integer                             $url_timeout                        = 30,
  Boolean                             $script_args_quoted                 = true,
  Stdlib::Absolutepath                $script_interpreter                 = '/bin/bash',

  Boolean                             $manage_home                        = true,
) {
  validate_rd_policy($admin_policies)
  validate_rd_policy($api_policies)

  contain rundeck::install
  contain rundeck::config
  contain rundeck::service

  # Class['rundeck::install']
  # -> Class['rundeck::config']
  # ~> Class['rundeck::service']
}
