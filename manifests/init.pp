# @summary Class to manage installation and configuration of Rundeck.
#
# @param acl_policies
#   Admin acl policies.
# @param acl_template
#   The template used for admin acl policy. Default is rundeck/aclpolicy.erb.
# @param api_policies
#   apitoken acl policies.
# @param auth_config
#   Authentication configuration.
# @param auth_template
#   The template used for authentication config. Default is rundeck/jaas-auth.conf.epp.
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
#   The template used for log properties. Default is rundeck/log4j.properties.erb.
# @param mail_config
#   A hash of the notification email configuraton.
# @param sshkey_manage
#   Should this module manage the sshkey used by rundeck at all.
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
# @param rd_loglevel
#   The log4j logging level to be set for the Rundeck application.
# @param rd_auditlevel
#   The log4j logging level to be set for the Rundeck application.
# @param rdeck_config_template
#   Allows you to override the rundeck-config template.
# @param rdeck_home
#   Directory under which the projects directories live.
# @param manage_home
#   Whether to manage rundeck home dir. Defaults to true.
# @param rdeck_profile_template
#   Allows you to use your own profile template instead of the default from the package maintainer
# @param rdeck_override_template
#   Allows you to use your own override template instead of the default from the package maintainer
# @param realm_template
#   Allows you to use your own override template instead of the default from the package maintainer
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
#   The path to the directory to store logs.
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
  Array[Hash]                         $acl_policies,
  Hash                                $framework_config,
  Array[Hash]                         $auth_config,
  Hash                                $database_config,
  Array[Hash]                         $key_storage_config,
  Hash                                $security_config,
  Hash                                $preauthenticated_config,
  String                              $keystore_password,
  String                              $truststore_password,
  Stdlib::Absolutepath                $file_keystorage_dir,
  Hash                                $repo_config,
  Boolean                             $manage_repo                        = true,
  String                              $package_ensure                     = 'installed',
  String                              $acl_template                       = 'rundeck/aclpolicy.erb',
  Array[Hash]                         $api_policies                       = [],
  String                              $auth_template                      = 'rundeck/jaas-auth.conf.epp',
  Boolean                             $clustermode_enabled                = false,
  Enum['active', 'passive']           $execution_mode                     = 'active',
  Hash                                $file_keystorage_keys               = {},
  Stdlib::HTTPUrl                     $grails_server_url                  = "http://${facts['networking']['fqdn']}:4440",
  Hash                                $gui_config                         = {},
  Optional[Stdlib::Absolutepath]      $java_home                          = undef,
  String                              $jvm_args                           = '-Xmx1024m -Xms256m -server',
  Hash                                $kerberos_realms                    = {},
  Stdlib::Absolutepath                $keystore                           = '/etc/rundeck/ssl/keystore',
  String                              $log_properties_template            = 'rundeck/log4j.properties.erb',
  Hash                                $mail_config                        = {},
  Boolean                             $sshkey_manage                      = true,
  Boolean                             $manage_default_admin_policy        = true,
  Boolean                             $manage_default_api_policy          = true,

  Rundeck::Loglevel                   $rd_loglevel                        = 'INFO',
  Rundeck::Loglevel                   $rd_auditlevel                      = 'INFO',
  String                              $rdeck_config_template              = 'rundeck/rundeck-config.epp',
  Stdlib::Absolutepath                $rdeck_home                         = '/var/lib/rundeck',
  Boolean                             $manage_home                        = true,
  Optional[String]                    $rdeck_profile_template             = undef,
  String                              $rdeck_override_template            = 'rundeck/profile_overrides.erb',
  String                              $realm_template                     = 'rundeck/realm.properties.epp',

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
  # Project management
  Hash                                $projects                           = {},
  String                              $projects_description               = '',
  String                              $projects_organization              = '',
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
) {
  validate_rd_policy($acl_policies)
  validate_rd_policy($api_policies)

  contain rundeck::install
  # contain rundeck::config
  contain rundeck::service

  # Class['rundeck::install']
  # -> Class['rundeck::config']
  # ~> Class['rundeck::service']
}
