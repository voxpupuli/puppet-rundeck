# 2016-05-26 - Release 3.0.0
### Summary
  - We dropped Ruby1.8 support!
  - Rundeck [preauthenticated-mode](http://rundeck.org/docs/administration/authenticating-users.html#preauthenticated-mode) mode config.
  - Several improvements and bugfixes.

#### Features
- Add ability to specify different project and key storage types [\#167](https://github.com/voxpupuli/puppet-rundeck/pull/167) ([jyaworski](https://github.com/jyaworski))
- Add support for customizing profile [\#174](https://github.com/voxpupuli/puppet-rundeck/pull/174) ([danifr](https://github.com/danifr))
- Support preauthenticated mode config [\#175](https://github.com/voxpupuli/puppet-rundeck/pull/175) ([danifr](https://github.com/danifr))
- Added management of scm-import.properties [\#193](https://github.com/voxpupuli/puppet-rundeck/pull/193) ([dalisch](https://github.com/dalisch))
- Add Rundeck GUI customization properties [\#210](https://github.com/voxpupuli/puppet-rundeck/pull/210) ([dalisch](https://github.com/dalisch))
- Add note and example about using an external MySQL DB [\#213](https://github.com/voxpupuli/puppet-rundeck/pull/213) ([zleswomp](https://github.com/zleswomp))
- Add CentOS 7 to tested platforms [\#214](https://github.com/voxpupuli/puppet-rundeck/pull/214) ([zleswomp](https://github.com/zleswomp))
- Add ability to specify node executor settings [\#217](https://github.com/voxpupuli/puppet-rundeck/pull/217) ([DevOpsFu](https://github.com/DevOpsFu))
- Add param to configure service state [\#223](https://github.com/voxpupuli/puppet-rundeck/pull/223) ([danifr](https://github.com/danifr))
- Do not write non-existent mail configuration [\#234](https://github.com/voxpupuli/puppet-rundeck/pull/234) ([ak0ska](https://github.com/ak0ska))
- Added option to template : 'forceBindingLoginUseRootContextForRoles' [\#228](https://github.com/voxpupuli/puppet-rundeck/pull/228) ([zlanyi](https://github.com/zlanyi))

#### Bugfixes
- Fix\(validate\_rd\_policy\) expand relative path for require [\#201](https://github.com/voxpupuli/puppet-rundeck/pull/201) ([igalic](https://github.com/igalic))
- Fix indentation for nodename property in aclpolicy template [\#209](https://github.com/voxpupuli/puppet-rundeck/pull/209) ([cy4n](https://github.com/cy4n))
- Fix audit loglevel 207 [\#212](https://github.com/voxpupuli/puppet-rundeck/pull/212) ([remixtj](https://github.com/remixtj))
- Documentation fixes [\#215](https://github.com/voxpupuli/puppet-rundeck/pull/215) ([zleswomp](https://github.com/zleswomp))
- Correcting values of project.organization and projection.description [\#221](https://github.com/voxpupuli/puppet-rundeck/pull/221) ([brmorris](https://github.com/brmorris))
- Simple fix aclpolicy.erb template [\#222](https://github.com/voxpupuli/puppet-rundeck/pull/222) ([devcfgc](https://github.com/devcfgc))

#### Improvements
- Simplify the acl template [\#173](https://github.com/voxpupuli/puppet-rundeck/pull/173) ([grafjo](https://github.com/grafjo))
- Default policy management is now optional [\#184](https://github.com/voxpupuli/puppet-rundeck/pull/184) ([bovy89](https://github.com/bovy89))
- Linting changes and rubocop updates [\#185](https://github.com/voxpupuli/puppet-rundeck/pull/185) ([jyaworski](https://github.com/jyaworski))
- Update from voxpupuli modulesync\_config [\#187](https://github.com/voxpupuli/puppet-rundeck/pull/187) ([jyaworski](https://github.com/jyaworski))
- Order variables alphabetically [\#189](https://github.com/voxpupuli/puppet-rundeck/pull/189) ([danifr](https://github.com/danifr))
- Remove auth-constraint from web.xml if preauthenticated mode enabled [\#190](https://github.com/voxpupuli/puppet-rundeck/pull/190) ([danifr](https://github.com/danifr))
- Ensure rundeck directories are owned by $user and $group [\#191](https://github.com/voxpupuli/puppet-rundeck/pull/191) ([danifr](https://github.com/danifr))
- Revert "Simplify the acl template" [\#195](https://github.com/voxpupuli/puppet-rundeck/pull/195) ([jyaworski](https://github.com/jyaworski))
- Pin rake to avoid rubocop/rake 11 incompatibility [\#200](https://github.com/voxpupuli/puppet-rundeck/pull/200) ([roidelapluie](https://github.com/roidelapluie))
- Refactored file permissions management [\#204](https://github.com/voxpupuli/puppet-rundeck/pull/204) ([dalisch](https://github.com/dalisch))
- Update \_auth\_file.erb \(fixes \#206\) [\#211](https://github.com/voxpupuli/puppet-rundeck/pull/211) ([remixtj](https://github.com/remixtj))
- Amend default policy for full storage control [\#216](https://github.com/voxpupuli/puppet-rundeck/pull/216) ([zleswomp](https://github.com/zleswomp))
- Automate configuration of SCM export properties in a project [\#218](https://github.com/voxpupuli/puppet-rundeck/pull/218) ([dalisch](https://github.com/dalisch))
- Allow disabling download of debian package. [\#219](https://github.com/voxpupuli/puppet-rundeck/pull/219) ([aequitas](https://github.com/aequitas))
- Simple fix qualify command [\#220](https://github.com/voxpupuli/puppet-rundeck/pull/220) ([devcfgc](https://github.com/devcfgc))
- Update from voxpupuli modulesync\_config [\#227](https://github.com/voxpupuli/puppet-rundeck/pull/227) ([jyaworski](https://github.com/jyaworski))

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
