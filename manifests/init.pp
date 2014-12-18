# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: rundeck
#
# This will install rundeck (http://rundeck.org/) and manage it's configration and plugins
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*package_ensure*]
#   Ensure the state of the rundeck package, either present, absent or a specific version
#
# [*jre_name*]
#   The name of the jre to be installed if using a custom jre.
#
# [*jre_ensure*]
#   Ensure the version of jre to be installed, either present, absent or a specific version
#
# [*jre_manage*]
#   Boolean value to set whether an installation of a JRE should be attempted.
#   If you set this to true, you are responsible for ensuring the package defined by
#   jre_name is available.
#
# [*auth_type*]
#   The method used to authenticate to rundeck. Default is file.
#
# [*properties_dir*]
#   The path to the configuration directory where the properties file are stored.
#
# [*service_logs_dir*]
#   The path to the directory to store logs.
#
# [*user*]
#   The user that rundeck is installed as.
#
# [*group*]
#   The group that the rundeck user is a member of.
#
# [*rdeck_base*]
#   The installation directory for rundeck.
#
# [*ssl_enabled*]
#   Enable ssl for the rundeck web application.
#
# [*projects_organization*]
#  The organization value that will be set by default for any projects.
#
# [*projects_description*]
#  The description that will be set by default for any projects.
#
# [*rd_loglevel*]
#  The log4j logging level to be set for the Rundeck application.
#
# [*rss_enabled*]
#  Boolean value if set to true enables RSS feeds that are public (non-authenticated)
#
# [*clustermode_enabled*]
#  Boolean value if set to true enables cluster mode
#
# [*grails_server_url*]
#  The url used in sending email notifications.
#
# [*keystore*]
#  Full path to the java keystore to be used by Rundeck.
#
# [*keystore_password*]
#  The password for the given keystore.
#
# [*key_password*]
#  The default key password.
#
# [*truststore*]
#  The full path to the java truststore to be used by Rundeck.
#
# [*truststore_password*]
#  The password for the given truststore.
#
# [*service_name*]
#  The name of the rundeck service.
#
# [*mail_config*]
#  A hash of the notification email configuraton.
#
# [*security_config*]
#  A hash of the rundeck security configuration.
#
# [*user*]
#   The user that rundeck is installed as.
#
# [*group*]
#   The group permission that rundeck is installed as.
#
# [*rdeck_home*]
#   directory under which the projects directories live.
# === Examples
#
# Installing rundeck with a custom jre:
#
# class { 'rundeck':
#   jre_name    => 'openjdk-7-jre',
#   jre_version => '7u51-2.4.4-0ubuntu0.12.04.2'
# }
#
class rundeck (
  $package_ensure               = $rundeck::params::package_ensure,
  $package_source               = $rundeck::params::package_source,
  $jre_name                     = $rundeck::params::jre_name,
  $jre_ensure                   = $rundeck::params::jre_ensure,
  $jre_manage                   = $rundeck::params::jre_manage,
  $auth_types                   = $rundeck::params::auth_types,
  $auth_template                = $rundeck::params::auth_template,
  $auth_config                  = $rundeck::params::auth_config,
  $acl_policies                 = $rundeck::params::acl_policies,
  $acl_template                 = $rundeck::params::acl_template,
  $service_logs_dir             = $rundeck::params::service_logs_dir,
  $ssl_enabled                  = $rundeck::params::ssl_enabled,
  $framework_config             = $rundeck::params::framework_config,
  $projects_organization        = $rundeck::params::projects_default_org,
  $projects_description         = $rundeck::params::projects_default_desc,
  $rd_loglevel                  = $rundeck::params::loglevel,
  $rss_enabled                  = $rundeck::params::rss_enabled,
  $clustermode_enabled          = $rundeck::params::clustermode_enabled,
  $grails_server_url            = $rundeck::params::grails_server_url,
  $database_config              = $rundeck::params::database_config,
  $keystore                     = $rundeck::params::keystore,
  $keystore_password            = $rundeck::params::keystore_password,
  $key_password                 = $rundeck::params::key_password,
  $truststore                   = $rundeck::params::truststore,
  $truststore_password          = $rundeck::params::truststore_password,
  $service_name                 = $rundeck::params::service_name,
  $service_manage               = $rundeck::params::service_manage,
  $service_script               = $rundeck::params::service_script,
  $service_config               = $rundeck::params::service_config,
  $mail_config                  = $rundeck::params::mail_config,
  $security_config              = $rundeck::params::security_config,
  $manage_yum_repo              = $rundeck::params::manage_yum_repo,
  $user                         = $rundeck::params::user,
  $group                        = $rundeck::params::group,
  $rdeck_home                   = $rundeck::params::rdeck_home,
) inherits rundeck::params {

  #validate_re($package_ensure, '\d+\.\d+\.\d+')

  validate_string($jre_name)
  validate_string($jre_ensure)
  validate_array($auth_types)
  validate_hash($auth_config)
  validate_hash($auth_users)
  validate_bool($ssl_enabled)
  validate_string($projects_organization)
  validate_string($projects_description)
  validate_re($rd_loglevel, ['^ALL$', '^DEBUG$', '^ERROR$', '^FATAL$', '^INFO$', '^OFF$', '^TRACE$', '^WARN$'])
  validate_bool($rss_enabled)
  validate_bool($clustermode_enabled)
  validate_string($grails_server_url)
  validate_hash($database_config)
  validate_absolute_path($keystore)
  validate_absolute_path($keystore)
  validate_string($keystore_password)
  validate_string($key_password)
  validate_absolute_path($truststore)
  validate_string($truststore_password)
  validate_string($service_name)
  validate_string($package_ensure)
  validate_hash($mail_config)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($rdeck_home)

  class { 'rundeck::install': } ->
  class { 'rundeck::config': } ->
  class { 'rundeck::service': } ->
  Class['rundeck']
}
