# @summary Class to manage installation and configuration of Rundeck.
#
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
# @param framework_config
#   Hash of properties for configuring the [Rundeck Framework](https://docs.rundeck.com/docs/administration/configuration/config-file-reference.html#framework-properties)
#   Default value is located in data/common.yaml.
# @param gui_config
#   Hash of properties for customizing the [Rundeck GUI](https://docs.rundeck.com/docs/administration/configuration/gui-customization.html)
# @param java_home
#   Set the home directory of java.
# @param jvm_args
#   Extra arguments for the JVM.
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
#   The password used to protect the key in keystore.
# @param ssl_private_key
#   Full path to the SSL private key to be used by Rundeck.
# @param ssl_certificate
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
# @param server_web_context
#   Web context path to use, such as "/rundeck". http://host.domain:port/server_web_context
# @param service_name
#   The name of the rundeck service.
# @param service_ensure
#   State of the rundeck service (defaults to 'running')
# @param service_logs_dir
#   The path to the directory to store service related logs.
# @param service_config
#   Allows you to use your own override template instead to config rundeckd init script.
# @param service_script
#   Allows you to use your own override template instead of the default from the package maintainer for rundeckd init script.
# @param grails_server_url
#   Sets `grails.serverURL` so that Rundeck knows its external address.
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
# @param key_storage_encrypt_config
#   Hash containing the necessary values to configure a plugin for key storage encryption.
#   https://docs.rundeck.com/docs/administration/configuration/plugins/configuring.html#storage-converter-plugins
# @param quartz_job_threadcount
#   The maximum number of threads used by Rundeck for concurrent jobs by default is set to 10.
#
class rundeck (
  Array[Hash]                    $admin_policies,
  Array[Hash]                    $api_policies,
  Rundeck::Auth_config           $auth_config,
  Rundeck::Db_config             $database_config,
  Hash                           $framework_config,
  Array[Hash]                    $key_storage_config,
  Stdlib::Absolutepath           $override_dir,
  Hash                           $repo_config,
  Boolean                        $manage_repo                 = true,
  String                         $package_ensure              = 'installed',
  Boolean                        $manage_home                 = true,
  String                         $user                        = 'rundeck',
  String                         $group                       = 'rundeck',
  Boolean                        $manage_user                 = false,
  Boolean                        $manage_group                = false,
  Optional[Integer]              $user_id                     = undef,
  Optional[Integer]              $group_id                    = undef,
  Stdlib::HTTPUrl                $grails_server_url           = "http://${facts['networking']['fqdn']}:4440",
  Boolean                        $clustermode_enabled         = false,
  Enum['active', 'passive']      $execution_mode              = 'active',
  Optional[Stdlib::Absolutepath] $java_home                   = undef,
  String                         $jvm_args                    = '-Xmx1024m -Xms256m -server',
  Integer                        $quartz_job_threadcount      = 10,
  Hash                           $gui_config                  = {},
  Rundeck::Mail_config           $mail_config                 = {},
  Hash                           $security_config             = {},
  Hash                           $preauthenticated_config     = {},
  Hash                           $key_storage_encrypt_config  = {},
  Boolean                        $manage_default_admin_policy = true,
  Boolean                        $manage_default_api_policy   = true,
  Rundeck::Loglevel              $app_log_level               = 'info',
  Rundeck::Loglevel              $audit_log_level             = 'info',
  String                         $config_template             = 'rundeck/rundeck-config.properties.epp',
  String                         $override_template           = 'rundeck/profile_overrides.epp',
  String                         $realm_template              = 'rundeck/realm.properties.epp',
  String                         $log_properties_template     = 'rundeck/log4j2.properties.epp',
  Boolean                        $rss_enabled                 = false,
  Optional[String]               $server_web_context          = undef,
  Boolean                        $ssl_enabled                 = false,
  Stdlib::Port                   $ssl_port                    = 4443,
  Stdlib::Absolutepath           $ssl_certificate             = '/etc/rundeck/ssl/rundeck.crt',
  Stdlib::Absolutepath           $ssl_private_key             = '/etc/rundeck/ssl/rundeck.key',
  Optional[String]               $key_password                = undef,
  Stdlib::Absolutepath           $keystore                    = '/etc/rundeck/ssl/keystore',
  String                         $keystore_password           = 'adminadmin',
  Stdlib::Absolutepath           $truststore                  = '/etc/rundeck/ssl/truststore',
  String                         $truststore_password         = 'adminadmin',
  String                         $service_name                = 'rundeckd',
  Enum['stopped', 'running']     $service_ensure              = 'running',
  Stdlib::Absolutepath           $service_logs_dir            = '/var/log/rundeck',
  Optional[String]               $service_config              = undef,
  Optional[String]               $service_script              = undef,
) {
  validate_rd_policy($admin_policies)
  validate_rd_policy($api_policies)

  contain rundeck::install
  contain rundeck::config
  contain rundeck::service

  Class['rundeck::install']
  -> Class['rundeck::config']
  ~> Class['rundeck::service']
}
