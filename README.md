# Rundeck module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-rundeck.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-rundeck)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-rundeck/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-rundeck)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with rundeck](#setup)
    * [What rundeck affects](#what-rundeck-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rundeck](#beginning-with-rundeck)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

The rundeck puppet module for installing and managing [Rundeck](http://rundeck.org/)


### Supported Versions of Rundeck

| Rundeck Version  | Rundeck Puppet module versions |
| ---------------- | -------------------------------|
| 2.x - 3.0.X      | v5.4.0 and older               |
| 3.1 - up         | v6.0.0 and newer               |

Since [Rundeck v3.1](https://docs.rundeck.com/docs/upgrading/upgrade-to-rundeck-3.1.html),
it is not required the installtion of `rundeck-config` package for RHEL based distributions anymore.

Rundeck Team decided to mark this package _obsolete_, making it difficult to maintain
backwards compatibility with releases older than 3.1.

Trying to install any version prior to 3.1.0 will throw the following error message:
```
Resolving Dependencies
--> Running transaction check
---> Package rundeck.noarch 0:2.11.5-1.56.GA will be installed
--> Processing Dependency: rundeck-config for package: rundeck-2.11.5-1.56.GA.noarch
Package rundeck-config is obsoleted by rundeck, but obsoleting package does not provide for requirements
...
```

If you need to downgrade and/or install a specific version of Rundeck older than 3.1.0, you can still use this module
to do it (v5.4.0 and prior), although you would need to [manually install the packages](https://github.com/rundeck/rundeck/issues/5168) disabling yum's obsoletes processing logic when performing updates.

Ex:
```
yum reinstall --setopt=obsoletes=0 rundeck-config-3.0.24.20190719-1.201907192053 rundeck-3.0.24.20190719-1.201907192053
```

The latest version of this puppet module only supports Rundeck 3.1 and up.

## Module Description

This module provides a way to manage the installation and configuration of
rundeck, its projects, jobs and plugins.

## Setup

###  Setup requirements

You need a compatible version of Java installed; you can use the
[puppetlabs/java](https://github.com/puppetlabs/puppetlabs-java) module if there
isn't already a suitable version.

On systems that use apt, there's a soft dependency on the
[puppetlabs/apt](https://github.com/puppetlabs/puppetlabs-apt) module.

### Classes and Defined Types

#### Class: `rundeck`

The rundeck module primary class, guides the basic installation and management
of rundeck on your system

**Parameters within `rundeck`:**
##### `package_ensure`

Ensure the state of the rundeck package, either present, absent or a specific version

##### `auth_types`

The method used to authenticate to Rundeck. Options: file, ldap,
active_directory, ldap_shared, active_directory_shared. Default is file.

##### `acl_template`

The template used for admin acl policy. Default is rundeck/aclpolicy.erb.

##### `api_template`

The template used for apitoken acl policy. Default is rundeck/aclpolicy.erb.

##### `properties_dir`

The path to the configuration directory where the properties file are stored.

##### `service_logs_dir`

The path to the directory to store logs.

##### `user`

The user that Rundeck is installed as.

##### `group`

The group that the Rundeck user is a member of.

##### `rdeck_base`

The installation directory for Rundeck.

##### `server_web_context`

Web context path to use, such as "/rundeck". `http://host.domain:port/server_web_context`

##### `ssl_enabled`

Enable ssl for the Rundeck web application.

##### `ssl_keyfile` and `ssl_certfile`

If ssl_enabled is True, you must supply this parameter. It is recommended that
you provide the .crt and .key files separately via other means, such as a role
or profile manifest.

How to: eg: environments/role/manifests/rundeck.pp

```Puppet

class role::rundeck (
...
  $ssl_keyfile                        = hiera('rundeck::config::ssl_keyfile', "/etc/rundeck/ssl/${facts['fqdn']}.key"),
  $ssl_certfile                       = hiera('rundeck::config::ssl_certfile', "/etc/rundeck/ssl/${facts['fqdn']}.crt"),
..
){
...
  validate_string($ssl_keyfile)
  validate_string($ssl_certfile)
...
  class { 'rundeck':
...
    ssl_keyfile                  => $ssl_keyfile,
    ssl_certfile                 => $ssl_certfile,
...
  }
...
}
```

Am End please add the module below to your environments/Puppetfile to use java_ks:

```Puppet
mod 'java_ks',
  :git => 'https://github.com/puppetlabs/puppetlabs-java_ks.git',
  :tag => '1.4.1'
```

##### `session_timeout`

Time limit (in minutes) for a logged in Rundeck web application user which as
been inactive for a period of time.

##### `projects`

The hash of projects in your instance.

##### `projects_organization`

The organization value that will be set by default for any projects.

##### `projects_description`

The description that will be set by default for any projects.

##### `quartz_job_threadcount`

The maximum number of threads used by Rundeck for concurrent jobs by default is set to 10.

##### `rd_loglevel`

The log4j logging level to be set for the Rundeck application.

##### `rdeck_profile_template` (**Requires Rundeck v2.8.x**)

Allows you to use your own profile template instead of the default from the package maintainer

##### `repo_apt_key_id`

Key ID for the GPG key for the Debian package

##### `repo_apt_keyserver`

Keysever for the GPG key for the Debian package

##### `repo_apt_source`

Baseurl for the apt repo

##### `repo_yum_gpgkey`

URL or path for the GPG key for the rpm

##### `repo_yum_source`

Baseurl for the yum repo

##### `rss_enabled`

Boolean value if set to true enables RSS feeds that are public (non-authenticated)

##### `clustermode_enabled`

Boolean value if set to true enables cluster mode

##### `grails_server_url`

The url used in sending email notifications.

##### `database_config`

A hash of the data base configuration. See [Configure a MySQL database](#configure-a-mysql-database) for an example.

##### `execution_mode`

If set, allows setting the execution mode to 'active' or 'passive'.
Defaults to undef.

##### `keystore`

Full path to the java keystore to be used by Rundeck.

##### `keystore_password`

The password for the given keystore.

##### `key_password`

The default key password.

##### `truststore`

The full path to the java truststore to be used by Rundeck.

##### `truststore_password`

The password for the given truststore.

##### `service_name`

The name of the rundeck service.

##### `mail_config`

A hash of the notification email configuraton.

##### `security_config`

A hash of the rundeck security configuration.

##### `security_role`

The name of the role that is required for all users to be allowed access.

##### `security_roles_array_enabled`

Boolean value if set to true enables security_roles_array.

##### `security_roles_array`

Array value if you want to have more role in web.xml

##### `storage_encrypt_config`

Hash containing the necessary values to configure a plugin for key storage
encryption.

##### `manage_repo`

Whether to manage the bintray YUM/APT repository containing the Rundeck rpm/deb. Defaults to true.

##### `manage_group`

Whether to manage `group` (and enforce `group_id` if set). Defaults to false.

##### `manage_user`

Whether to manage `user` (and enforce `user_id` if set). Defaults to false.

##### `manage_home`

Whether to create the `rundeck_home` directory. Defaults to true.

##### `keystorage_type`

Which keystorage type should be used:

* file - Default file based keystorage
* db - Use DB as keystorage
* vault - Use Hashicorp Vault
  - An additional [Rundeck Vault plugin](https://github.com/rundeck-plugins/vault-storage/) is required.

##### `file_keystorage_dir`

The location of stored data like public keys, private keys.

##### `vault_keystorage_prefix`

The prefix for the Hashicorp Vault keys. See [here](https://github.com/rundeck-plugins/vault-storage) for more information.

##### `vault_keystorage_url`

The URL for the Hashicorp Vault service

##### `vault_keystorage_approle_approleid`

The AppRole ID for the Hashicorp Vault access

##### `vault_keystorage_approle_secretid`

The Secret ID for the Hashicorp Vault access. Please note, that the Vault plugin isn't able to refresh the SecretID while running. You have to add a Cron job, to restart Rundeck. See [here](https://github.com/rundeck-plugins/vault-storage/issues/15#issuecomment-512815828) for more information.

##### `vault_keystorage_approle_authmount`

The AppRole Authmount for the Hashicorp Vault access

##### `vault_keystorage_authbackend`

The AuthBackend for the Hashicorp Vault, which should used

#### Define: `rundeck::config::aclpolicyfile`

A definition for creating custom acl policy files

##### `acl_policies`

An array containing ACL policies. See rundeck::params::acl_policies /
rundeck::params::api_policies as an example.

##### `owner`

The user that rundeck is installed as.

##### `group`

The group permission that rundeck is installed as.

##### `properties_dir`

The rundeck configuration directory.

#### Define: `rundeck::config::plugin`

A definition for installing rundeck plugins

**Parameters within `rundeck::config::plugin`:**

##### `source`

The http source or local path from which to get the jar plugin.

##### `ensure`

Default set to 'present' and can be set to 'absent' to remove the plugin for the
system.

##### `timeout`

Timeout in seconds.  Default is set to 300 seconds which is the default for the
Exec type.

#### Define: `rundeck::config::project`

A definition for managing rundeck projects

**Parameters within `rundeck::project`:**

##### `file_copier_provider`

The type of proivder that will be used for copying files to each of the nodes

##### `node_executor_provider`

The type of provider that will be used to gather node resources

##### `resource_sources`

A hash of rundeck::config::resource_source that will be used to specifiy the node
resources for this project

##### `ssh_keypath`

The path the the ssh key that will be used by the ssh/scp providers

##### `projects_dir`

The directory where rundeck is configured to store project information

##### `user`

The user that rundeck is installed as.

##### `group`

The group permission that rundeck is installed as.

#### Define: `rundeck::config::resource_source`

A definition for managing the resource sources for a given project

**Parameters within `rundeck::resource_source`:**

##### `project_name`

The name of the project for which this resource in intended to be a part.

##### `number`

The sequential number of the resource within the project.

##### `source_type`

The source type where resources will come from: file, directory, url or script.

##### `include_server_node`

Boolean value to decide whether or not to include the server node in your list
of avaliable nodes.

##### `resource_format`

The format of the resource that will procesed, either resourcexml or resourceyaml.

##### `url`

When the url source_type is specified this is the path to that url.

##### `url_timeout`

An integer value in seconds that rundeck will wait for resources from the url
before timing out.

##### `url_cache`

Boolean value. Keep a local cache of the resources pulled from the url.

##### `directory`

When the directory source_type is specified this is the path to that directory.

##### `script_file`

When the script source_type is specified this is the path that that script.

##### `script_args`

A string of the full arguments to pass the the specified script.

##### `script_args_quoted`

Boolean value. Quote the arguments of the script.

##### `script_interpreter`

The interpreter to use in executing the script. Defaults to: '/bin/bash'

##### `service_config`

(Optional) Template for rundeckd.conf

##### `service_script`

(Optional) Template to use for rundeckd init script.

##### `projects_dir`

The directory where rundeck is configured to store project information.

##### `user`

The user that rundeck is installed as.

##### `group`

The group permission that rundeck is installed as.

## Usage

### Configuring shared authentication credentials

To perform LDAP authentication and file authorization see example examples/ldap\_shared.pp

### Configure a MySQL database

To use an external MySQL database, the `database_config` hash must be set to
override the default values which result in a local file based storage.  To
enable `key` and `project` storage in the database, you must also set the two
associated parameters.

```puppet
class { 'rundeck':
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

## Reference

### Classes

#### Public Classes

* [`rundeck`](#class-rundeck): Guides the basic installation of rundeck

#### Private Classes

* [`rundeck::install`](#class-install): Manages the installation of the rundeck packages
* [`rundeck::service`](#class-service): Manages the rundeck service
* [`rundeck::config`](#class-config): Manages all the global configuration of
  the rundeck application
* [`rundeck::config::global::framework`](#class-framework): Manage the configuration
  of shell tools and core rundeck services
* [`rundeck::config::global::project`](#class-project): Managed the rundeck
  project configuration
* [`rundeck::config::global::rundeck_config`](#class-rundeckconfig): Manages the
  rundeck webapp configuration file
* [`rundeck::config::global::ssl`](#class-ssl): Manages the ssl configuration for
  the rundeck webapp

### Defines

#### Public Defines

* [`rundeck::config::aclpolicyfile`](#define-aclpolicyfile): Manages a acl policy
  file
* [`rundeck::config::plugin`](#define-rundeckplugin): Manages the installation of
  rundeck plugins
* [`rundeck::config::project`](#define-rundeckproject): Manages the configuration
  of rundeck projects
* [`rundeck::config::resource_source`](#define-rundeckresource_source): Manages
  resource sources for each project

## Limitations

This module is tested on the following platforms:

* Debian 8
* CentOS 6
* CentOS 7
* Ubuntu 16.04

It is tested with the OSS version of Puppet only.

## Development

### Contributing
This module is maintained by [Vox Pupuli](https://voxpupuli.org/). Vox Pupuli
welcomes new contributions to this module, especially those that include
documentation and rspec tests. We are happy to provide guidance if necessary.

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for more details.
