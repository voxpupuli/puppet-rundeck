##2015-05-22 - Relese 1.2.0
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
