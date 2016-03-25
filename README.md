# puppet-rundeck

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rundeck](#setup)
    * [What rundeck affects](#what-rundeck-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rundeck](#beginning-with-rundeck)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The rundeck puppet module for installing and managing rundeck (http://rundeck.org/)

[![Build Status](https://travis-ci.org/voxpupuli/puppet-rundeck.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-rundeck)

##Module Description

This module provides a way to manage the installation and configuration of rundeck, it's projects, jobs and plugins.

##Setup

###Classes and Defined Types

####Class: `rundeck`
The rundeck module primary class, guides the basic installation and management of rundeck on your system

**Parameters within `rundeck`:**
#####`package_ensure`
Ensure the state of the rundeck package, either present, absent or a specific version

#####`auth_types`
The method used to authenticate to Rundeck. Options: file, ldap, active_directory, ldap_shared,
active_directory_shared. Default is file.

#####`acl_template`
The template used for admin acl policy. Default is rundeck/aclpolicy.erb.

#####`api_template`
The template used for apitoken acl policy. Default is rundeck/aclpolicy.erb.

#####`properties_dir`
The path to the configuration directory where the properties file are stored.

#####`log_dir`
The path to the directory to store logs.

#####`user`
The user that Rundeck is installed as.

#####`group`
The group that the Rundeck user is a member of.

#####`rdeck_base`
The installation directory for Rundeck.

#####`server_web_context`
Web context path to use, such as "/rundeck". http://host.domain:port/server_web_context

#####`ssl_enabled`
Enable ssl for the Rundeck web application.

#####`session_timeout`
Time limit (in minutes) for a logged in Rundeck web application user which as been inactive for a period of time.

#####`projects`
The hash of projects in your instance.

#####`projects_organization`
The organization value that will be set by default for any projects.

#####`projects_description`
The description that will be set by default for any projects.

#####`rd_loglevel`
The log4j logging level to be set for the Rundeck application.

#####`rss_enabled`
Boolean value if set to true enables RSS feeds that are public (non-authenticated)

#####`clustermode_enabled`
Boolean value if set to true enables cluster mode

#####`grails_server_url`
The url used in sending email notifications.

#####`dataSource_config`
A hash of the data Source configuraton.

#####`keystore`
Full path to the java keystore to be used by Rundeck.

#####`keystore_password`
The password for the given keystore.

#####`key_password`
The default key password.

#####`truststore`
The full path to the java truststore to be used by Rundeck.

#####`truststore_password`
The password for the given truststore.

#####`service_name`
The name of the rundeck service.

#####`mail_config`
A hash of the notification email configuraton.

#####`security_config`
A hash of the rundeck security configuration.

#####`security_role`
The name of the role that is required for all users to be allowed access.

#####`manage_yum_repo`
Whether to manage the YUM repository containing the Rundeck rpm. Defaults to true.

#####`file_keystorage_dir`
The location of stored data like public keys, private keys.

####Define: `aclpolicyfile`
A definition for creating custom acl policy files

#####`acl_policies`
An array containing acl policies. See rundeck::params::acl_policies / rundeck::params::api_policies as an example.

#####`owner`
The user that rundeck is installed as.

#####`group`
The group permission that rundeck is installed as.

#####`properties_dir`
The rundeck configuration directory.

####Define: `rundeck::plugin`
A definition for installing rundeck plugins

**Parameters within `rundeck::plugin`:**

#####`source`
The http source or local path from which to get the jar plugin.

#####`ensure`
Default set to 'present' and can be set to 'absent' to remove the plugin for the system

#####`timeout`
Timeout in seconds.  Default is set to 300 seconds which is the default for the Exec type.

####Define: `rundeck::project`
A definition for managing rundeck projects

**Parameters within `rundeck::project`:**

#####`file_copier_provider`
The type of proivder that will be used for copying files to each of the nodes

#####`node_executor_provider`
The type of provider that will be used to gather node resources

#####`resource_sources`
A hash of rundeck::config::resource_source that will be used to specifiy the node
resources for this project

#####`ssh_keypath`
The path the the ssh key that will be used by the ssh/scp providers

#####`projects_dir`
The directory where rundeck is configured to store project information

#####`user`
The user that rundeck is installed as.

#####`group`
The group permission that rundeck is installed as.

####Define: `rundeck::resource_source`
A definition for managing the resource sources for a given project

**Parameters within `rundeck::resource_source`:**

#####`project_name`
The name of the project for which this resource in intended to be a part.

#####`number`
The sequential number of the resource within the project.

#####`source_type`
The source type where resources will come from: file, directory, url or script.

#####`include_server_node`
Boolean value to decide whether or not to include the server node in your list of avaliable nodes.

#####`resource_format`
The format of the resource that will procesed, either resourcexml or resourceyaml.

#####`url`
When the url source_type is specified this is the path to that url.

#####`url_timeout`
An integer value in seconds that rundeck will wait for resources from the url before timing out.

#####`url_cache`
Boolean value. Keep a local cache of the resources pulled from the url.

#####`directory`
When the directory source_type is specified this is the path to that directory.

#####`script_file`
When the script source_type is specified this is the path that that script.

#####`script_args`
A string of the full arguments to pass the the specified script.

#####`script_args_quoted`
Boolean value. Quote the arguments of the script.

#####`script_interpreter`
The interpreter to use in executing the script. Defaults to: '/bin/bash'

#####`projects_dir`
The directory where rundeck is configured to store project information.

#####`user`
The user that rundeck is installed as.

#####`group`
The group permission that rundeck is installed as.

##Usage

###Configuring shared authentication credentials
To perform LDAP authentication and file authorization see example examples/ldap\_shared.pp

###Configure a MySQL database

To use an external MySQL database, the `database_config` hash must be set to
override the default values which result in a local file based storage.  To
enable `key` and `project` storage in the database, you must also set the two
parameters associated parameters.

```puppet
class { '::rundeck':
  key_storage_type      => 'db',
  projects_storage_type => 'db',
  database_config       => {
    'type'              => 'mysql',
    'url'               => $db_url,
    'username'          => 'rundeck',
    'password'          => $db_pass,
    'driverClassName'   => 'com.mysql.jdbc.Driver',
  }
}
```

##Reference

###Classes
####Public Classes
* [`rundeck`](#class-rundeck): Guides the basic installation of rundeck

####Private Classes
* [`rundeck::install`](#class-install): Manages the installation of the rundeck packages
* [`rundeck::service`](#class-service): Manages the rundeck service
* [`rundeck::config`](#class-config): Manages all the global configuration of the rundeck application
* [`rundeck::config::global::framework`](#class-framework): Manage the configuration of shell tools and core rundeck services
* [`rundeck::config::global::project`](#class-project): Managed the rundeck project configuration
* [`rundeck::config::global::rundeck_config`](#class-rundeckconfig): Manages the rundeck webapp configuration file
* [`rundeck::config::global::ssl`](#class-ssl): Manages the ssl configuration for the rundeck webapp

###Defines
####Public Defines
* [`rundeck::config::aclpolicyfile`](#define-aclpolicyfile): Manages a acl policy file
* [`rundeck::config::plugin`](#define-rundeckplugin): Manages the installation of rundeck plugins
* [`rundeck::config::project`](#define-rundeckproject): Manages the configuration of rundeck projects
* [`rundeck::config::resource_source`](#define-rundeckresource_source): Manages resource sources for each project


##Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* Ubuntu 12.04
* Ubuntu 14.04

It is tested with the OSS version of Puppet only.

##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
