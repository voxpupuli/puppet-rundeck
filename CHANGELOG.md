#2016-02-19 - Release 2.2.0
### Summary
  New defined type for managing file-based keystores and lots of bugfixes.

#### Features
- Adding new defined type `rundeck::config::file_keystore` for provisioning of password and public keys for file-based keystorage (#172)

#### Bugfixes
- Adding missing ssh_keypath to project defined type (#153)
- Added ldap login module if ldap in the provided auth_types (#163)
- Ensuring config that uses ini_file always uses string values (#164)
- Adding 'rundeck_server' property to acl_template (#148)
- Fix validation of resource_source number parameter (#171)

#### Improvements
- Disable H2 database logging in log4j.properties (#161)
- Move rundeck_version to a proper fact (#165)

##2015-11-20 - Release 2.1.0
### Summary
Fixing the autoload bug in the new acl validation function.
Lots of new parameters to customize settings.

#### Features
- Added support for shared authentication credentials
- Added RHEL7/CentOS7 to supported OS list
- Added new class `rundeck::config::global::web` to manage security-role in web.xml
- Added examples
- New parameter `projects` to allow you to prove a hash of `rundeck::config::project` instances
- New parameter `realm_template` allowing you to override the realm.properties template
- New parameter `rdeck_config_template` allowing you to override the rundeck-config template
- New parameter `session_timeout` to allow modification of the gui session timeout in web.xml
- New parameter `file_keystorage_dir` to allow non-default path to key storage

#### Bugfixes
- Fixing the autoload of the rundeck_acl function
- Ensure ssl configuration is only included when `ssl_enabled` is set.
- Fixed syntax in facts
- Removed the java dependency from the package install.
- Fixing bugs in the aclpolicy template

##2015-09-11 - Release 2.0.0
###Summary

####Features
- New defined type `rundeck::config::aclpolicyfile`
- Refactored plugin installation to use puppet/archive
- Refactored `rundeck::config::resource_source`
- New class `rundeck::facts` to install rundeck facts and external facts
- Added param `server_web_context` to pass into the JVM args
- Add support for a different JAVA_HOME directory
- Added new function to validate acl policies
- Added support for PAM authentication

#### Bugfixes
- Ensure service is restarted on all config changes
- Support installing rundeck with non-default user and groups
- Fixing bind CN for ldap configuration
- Fix the projects directory default in framework.properties
- Download packages over https

#### Breaking changes
- Removed params `plugin_dir`, `user` and `group` from `rundeck::config::plugin`
- Removed params `user` and `group` from `rundeck::config::resource_source`
- Removed the management of the JRE
- Changes the format of the acl polices hash - see params.pp for example.

##2015-05-22 - Release 1.2.0
###Summary

  Support for API ACLS and some bug fixes for RedHat/CentOS

####Features
- Add support for multiple auth users
- Add option to configure API acls

####Bugfixes
- Fix bug with grails.mail.default.from
- Fix rundeck_version fact on RHEL-based systems
- Require java 7 for RHEL based systems
- Fix user and group for project directory
- Ensure service is restarted after upgrade on RHEL based systems
- Adding missing storage rule to acl policy defaults

##2015-03-24 - Release 1.1.0
###Summary

  This release contained many new features and refactorings. Exciting stuff.

####Features
- Allow optional management of the JRE
- Add initial support for support for clustermode
- Allow an alternative service script
- Add LDAP + ActiveDirectory login support
- Make managing the yum repository optional
- Adding support for alternative database configurations
- Refactoring rundeck-config from `ini_setting`s to groovy format
- Add support for passing e-email configuration to grails

####Bugfixes
- Fix deep merging of framework_config
- Make sure that changes in the ssl settings trigger a restart in the rundeckd service
- Fixing lots of beaker tests

##2014-10-13 - Release 1.0.0
###Summary

  This release is focused on cleaning up the module and closing down a number of annoying bugs that have been around a while.
  Some refactoring has also taken place to make it a little eaiser and cleaner to add features in further reeleases.

####Features
- adding support for the redhat rundeck repo
- updating default rundeck version to 2.2.3
- improving documentation and tests

####Bugfixes
- fixing bug in layout of admin.aclpolicy file
- fixing default config settings for servername and grails_server_url which causes bug in page loading
- fixing some idempotency issues
- refactoring the configuration of the module

##2014-04-04 - Release 0.2.0
###Summary

  This release is focused on managing more configuration and resources in the rundeck application

####Features
- adding definitions for plugins, projects, and resource sources
- adding support for managing the majority of the Rundeck configuration
- more tests

##2014-03-28 - Release 0.1.0
###Summary

  Initial release.
