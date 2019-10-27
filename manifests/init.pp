# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: rundeck
#
# This will install rundeck (http://rundeck.org/) and manage its configration and plugins
#
# === Parameters
#
# [*acl_template*]
#   The template used for admin acl policy. Default is rundeck/aclpolicy.erb.
#
# [*api_template*]
#   The template used for apitoken acl policy. Default is rundeck/aclpolicy.erb.
#
# [*auth_types*]
#   The method used to authenticate to rundeck. Default is file.
#
# [*clustermode_enabled*]
#  Boolean value if set to true enables cluster mode
#
# [*execution_mode*]
#  If set, allows setting the execution mode to 'active' or 'passive'.
#
# [*grails_server_url*]
#  Sets `grails.serverURL` so that Rundeck knows its external address.
#
# [*repo_apt_key_id*]
#
# Key ID for the GPG key for the Debian package
#
# [*repo_apt_keyserver*]
#
# Keysever for the GPG key for the Debian package
#
# [*repo_apt_source*]
#
# Baseurl for the apt repo
#
# [*repo_yum_gpgkey*]
#
# URL or path for the GPG key for the rpm
#
# [*repo_yum_source*]
#
# Baseurl for the yum repo
#
# [*ssl_keyfile*]
#  Full path to the SSL private key to be used by Rundeck.
#
# [*ssl_certfile*]
#  Full path to the SSL public key to be used by Rundeck.
#
# [*group*]
#  The group permission that rundeck is installed as.
#
# [*gui_config*]
#  Hash of properties for customizing the [Rundeck GUI](http://rundeck.org/docs/administration/gui-customization.html)
#
# [*java_home*]
#  Set the home directory of java.
#
# [*jvm_args*]
#  Extra arguments for the JVM.
#
# [*kerberos_realms*]
# A hash of mappings between Kerberos domain DNS names and realm names
#
# [*key_password*]
#  The default key password.
#
# [*key_storage_type*]
#  Type used to store secrets. Must be 'file', 'db' or 'vault'
#
# [*keystore*]
#  Full path to the java keystore to be used by Rundeck.
#
# [*keystore_password*]
#  The password for the given keystore.
#
# [*mail_config*]
#  A hash of the notification email configuraton.
#
# [*manage_default_admin_policy*]
#  Boolean value if set to true enables default admin policy management
#
# [*manage_default_api_policy*]
#  Boolean value if set to true enables default api policy management
#
# [*manage_group*]
#
# Whether to manage `group` (and enforce `group_id` if set). Defaults to false.
#
# [*manage_user*]
#
# Whether to manage `user` (and enforce `user_id` if set). Defaults to false.
#
# [*package_ensure*]
#  Ensure the state of the rundeck package, either present, absent or a specific version
#
# [*preauthenticated_config*]
#  A hash of the rundeck preauthenticated config mode
#
# [*projects*]
#  The hash of projects in your instance.
#
# [*projects_description*]
#  The description that will be set by default for any projects.
#
# [*projects_organization*]
#  The organization value that will be set by default for any projects.
#
# [*projects_storage_type*]
#  The storage type for any projects. Must be 'filesystem' or 'db'
#
# [*properties_dir*]
#  The path to the configuration directory where the properties file are stored.
#
# [*quartz_job_threadcount*]
#  The maximum number of threads used by Rundeck for concurrent jobs by default is set to 10.
#
# [*rd_loglevel*]
#  The log4j logging level to be set for the Rundeck application.
#
# [*rd_auditlevel*]
#  The log4j logging level to be set for the Rundeck application.
#
# [*rdeck_base*]
#  The installation directory for rundeck.
#
# [*rdeck_config_template*]
#  Allows you to override the rundeck-config template
#
# [*rdeck_home*]
#  directory under which the projects directories live.
#
# [*rdeck_profile_template*]
#  Allows you to use your own profile template instead of the default from the package maintainer
#
# [*rss_enabled*]
#  Boolean value if set to true enables RSS feeds that are public (non-authenticated)
#
# [*security_config*]
#  A hash of the rundeck security configuration.
#
# [*security_role*]
#  Name of the role that is required for all users to be allowed access.
#
# [*server_web_context*]
#  Web context path to use, such as "/rundeck". http://host.domain:port/server_web_context
#
# [*service_logs_dir*]
#  The path to the directory to store logs.
#
# [*service_name*]
#  The name of the rundeck service.
#
#  [*service_ensure*]
#  State of the rundeck service (defaults to 'running')
#
# [*session_timeout*]
#  Session timeout is an expired time limit for a logged in Rundeck GUI user which as been inactive for a period of time.
#
# [*sshkey_manage*]
#  Should this module manage the sshkey used by rundeck at all.
#
# [*ssl_enabled*]
#  Enable ssl for the rundeck web application.
#
# [*ssl_port*]
#  ssl port of the rundeck web application (default to '4443').
#
# [*truststore*]
#  The full path to the java truststore to be used by Rundeck.
#
# [*truststore_password*]
#  The password for the given truststore.
#
# [*user*]
#  The user that rundeck is installed as.
#
# [*user_id*]
#  If you want to have always the same user id. Eg. because of the NFS share.
#
# [*group_id*]
#  If you want to have always the same group id. Eg. because of the NFS share.
#
# [*security_roles_array_enabled*]
#  Boolean value if you need more roles. false or true (default is false).
#
# [*security_roles_array*]
#  Array value if you need more roles and you set true the "security_roles_array_enabled" value.
#  Example: my.hiera.yaml:
#  ...
#  rundeck::config::global::web::security_roles_array_enabled: true
#  rundeck::config::global::web::security_roles_array:
#    - DevOps
#    - roots_ito
#  ...
#  In your class:
#  $security_roles_array_enabled = hiera('rundeck::config::global::web::security_roles_array_enabled', true),
#  $security_roles_array         = hiera('rundeck::config::global::web::security_roles_array', []),
#
class rundeck (
  Array[Hash] $acl_policies                                     = $rundeck::params::acl_policies,
  String $acl_template                                          = $rundeck::params::acl_template,
  Array[Hash] $api_policies                                     = $rundeck::params::api_policies,
  String $api_template                                          = $rundeck::params::api_template,
  Hash $auth_config                                             = $rundeck::params::auth_config,
  String $auth_template                                         = $rundeck::params::auth_template,
  Array $auth_types                                             = $rundeck::params::auth_types,
  Boolean $clustermode_enabled                                  = $rundeck::params::clustermode_enabled,
  Hash $database_config                                         = $rundeck::params::database_config,
  Optional[Enum['active', 'passive']] $execution_mode           = undef,
  Stdlib::Absolutepath $file_keystorage_dir                     = $rundeck::params::file_keystorage_dir,
  Hash $file_keystorage_keys                                    = $rundeck::params::file_keystorage_keys,
  Hash $framework_config                                        = $rundeck::params::framework_config,
  Stdlib::HTTPUrl $grails_server_url                            = $rundeck::params::grails_server_url,
  Hash $gui_config                                              = $rundeck::params::gui_config,
  Optional[Stdlib::Absolutepath] $java_home                     = undef,
  String $jvm_args                                              = $rundeck::params::jvm_args,
  Hash $kerberos_realms                                         = $rundeck::params::kerberos_realms,
  String $key_password                                          = $rundeck::params::key_password,
  Enum['db', 'file', 'vault'] $key_storage_type                 = $rundeck::params::key_storage_type,
  Stdlib::Absolutepath $keystore                                = $rundeck::params::keystore,
  Optional[Stdlib::HTTPSUrl] $vault_keystorage_url              = undef,
  Optional[String[1]] $vault_keystorage_prefix                  = undef,
  Optional[String[1]] $vault_keystorage_approle_approleid       = undef,
  Optional[String[1]] $vault_keystorage_approle_secretid        = undef,
  Optional[String[1]] $vault_keystorage_approle_authmount       = undef,
  Optional[String[1]] $vault_keystorage_authbackend             = undef,
  String $keystore_password                                     = $rundeck::params::keystore_password,
  String $log_properties_template                               = $rundeck::params::log_properties_template,
  Hash $mail_config                                             = $rundeck::params::mail_config,
  Boolean $sshkey_manage                                        = $rundeck::params::sshkey_manage,
  Stdlib::Absolutepath $ssl_keyfile                             = $rundeck::params::ssl_keyfile,
  Stdlib::Absolutepath $ssl_certfile                            = $rundeck::params::ssl_certfile,
  Boolean $manage_default_admin_policy                          = $rundeck::params::manage_default_admin_policy,
  Boolean $manage_default_api_policy                            = $rundeck::params::manage_default_api_policy,
  Boolean $manage_repo                                          = $rundeck::params::manage_repo,
  String $package_ensure                                        = $rundeck::params::package_ensure,
  Hash $preauthenticated_config                                 = $rundeck::params::preauthenticated_config,
  Hash $projects                                                = $rundeck::params::projects,
  String $projects_description                                  = $rundeck::params::projects_default_desc,
  String $projects_organization                                 = $rundeck::params::projects_default_org,
  Enum['db', 'filesystem'] $projects_storage_type               = $rundeck::params::projects_storage_type,
  Integer $quartz_job_threadcount                               = $rundeck::params::quartz_job_threadcount,
  Rundeck::Loglevel $rd_loglevel                                = $rundeck::params::loglevel,
  Rundeck::Loglevel $rd_auditlevel                              = $rundeck::params::loglevel,
  String $rdeck_config_template                                 = $rundeck::params::rdeck_config_template,
  Stdlib::Absolutepath $rdeck_home                              = $rundeck::params::rdeck_home,
  Boolean $manage_home                                          = $rundeck::params::manage_home,
  Optional[String] $rdeck_profile_template                      = undef,
  String $realm_template                                        = $rundeck::params::realm_template,
  Stdlib::HTTPUrl $repo_yum_source                              = $rundeck::params::repo_yum_source,
  String $repo_yum_gpgkey                                       = $rundeck::params::repo_yum_gpgkey,
  Stdlib::HTTPUrl $repo_apt_source                              = $rundeck::params::repo_apt_source,
  String $repo_apt_key_id                                       = $rundeck::params::repo_apt_key_id,
  String $repo_apt_keyserver                                    = $rundeck::params::repo_apt_keyserver,
  Boolean $rss_enabled                                          = $rundeck::params::rss_enabled,
  Hash $security_config                                         = $rundeck::params::security_config,
  String $security_role                                         = $rundeck::params::security_role,
  Optional[String] $server_web_context                          = undef,
  Optional[String] $service_config                              = undef,
  Stdlib::Absolutepath $service_logs_dir                        = $rundeck::params::service_logs_dir,
  String $service_name                                          = $rundeck::params::service_name,
  Optional[String] $service_script                              = undef,
  Enum['stopped', 'running'] $service_ensure                    = $rundeck::params::service_ensure,
  Integer $session_timeout                                      = $rundeck::params::session_timeout,
  Boolean $ssl_enabled                                          = $rundeck::params::ssl_enabled,
  Stdlib::Port $ssl_port                                        = $rundeck::params::ssl_port,
  Stdlib::Absolutepath $truststore                              = $rundeck::params::truststore,
  String $truststore_password                                   = $rundeck::params::truststore_password,
  String $user                                                  = $rundeck::params::user,
  String $group                                                 = $rundeck::params::group,
  Boolean $manage_user                                          = $rundeck::params::manage_user,
  Boolean $manage_group                                         = $rundeck::params::manage_group,
  Optional[Integer] $user_id                                    = undef,
  Optional[Integer] $group_id                                   = undef,
  String $file_default_mode                                     = $rundeck::params::file_default_mode,
  Boolean $security_roles_array_enabled                         = $rundeck::params::security_roles_array_enabled,
  Array $security_roles_array                                   = $rundeck::params::security_roles_array,
) inherits rundeck::params {

  validate_rd_policy($acl_policies)

  contain rundeck::install
  contain rundeck::config
  contain rundeck::service

  Class['rundeck::install']
  -> Class['rundeck::config']
  ~> Class['rundeck::service']

}
