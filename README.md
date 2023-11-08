# Rundeck module for Puppet

[![Build Status](https://github.com/voxpupuli/puppet-rundeck/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-rundeck/actions?query=workflow%3ACI)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-rundeck/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-rundeck)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/rundeck.svg)](https://forge.puppetlabs.com/puppet/rundeck)

## Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - Requirements and beginning with rundeck](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - Module references](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

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

```console
Resolving Dependencies
--> Running transaction check
---> Package rundeck.noarch 0:2.11.5-1.56.GA will be installed
--> Processing Dependency: rundeck-config for package: rundeck-2.11.5-1.56.GA.noarch
Package rundeck-config is obsoleted by rundeck, but obsoleting package does not provide for requirements
...
```

If you need to downgrade and/or install a specific version of Rundeck older than 3.1.0, you can still use this module
to do it (v5.4.0 and prior), although you would need to [manually install the packages](https://github.com/rundeck/rundeck/issues/5168) disabling yum's obsoletes processing logic when performing updates.

```console
yum reinstall --setopt=obsoletes=0 rundeck-config-3.0.24.20190719-1.201907192053 rundeck-3.0.24.20190719-1.201907192053
```

The latest version of this puppet module only supports Rundeck 3.1 and up.

## Module Description

This module provides a way to manage the installation and configuration of
rundeck, its projects, jobs and plugins.

## Setup

### Requirements

You need a compatible version of Java installed.
You can use [puppetlabs/java](https://github.com/puppetlabs/puppetlabs-java) module if there isn't already a suitable version.

On systems that use apt, there's a soft dependency on the [puppetlabs/apt](https://github.com/puppetlabs/puppetlabs-apt) module.

### Beginning with rundeck

To install a server with the default options:

```puppet
include rundeck
```

## Usage

### Configure rundeck to connect to a MySQL database

To use an external MySQL database, the `database_config` hash must be set to
override the default values which result in a local file based storage.  To
enable `key` and `project` storage in the database, you must also set the two
associated parameters.

```puppet
class { 'rundeck':
  key_storage_type      => 'db',
  projects_storage_type => 'db',
  database_config       => {
    'type'            => 'mysql',
    'url'             => $db_url,
    'username'        => 'rundeck',
    'password'        => $db_pass,
    'driverClassName' => 'com.mysql.jdbc.Driver',
  },
}
```

### Configure SSL for rundeck

```Puppet
class { 'rundeck':
  ssl_enabled  => true,
  ssl_keyfile  => $ssl_keyfile,
  ssl_certfile => $ssl_certfile,
}
```

### Use HashiCorp vault as keystorage

An additional [Rundeck Vault plugin](https://github.com/rundeck-plugins/vault-storage/) is required.

```Puppet
class { 'rundeck':
  key_storage_type                   => 'vault',
  vault_keystorage_url               => 'https://vault.example.com',
  vault_keystorage_prefix            => 'rundeck',
  vault_keystorage_approle_approleid => 'xxx-xxx-xxx-xxx-xxx',
  vault_keystorage_approle_secretid  => 'xxx-xxx-xxx-xxx-xxx',
  vault_keystorage_approle_authmount => 'approle',
  vault_keystorage_authbackend       => 'approle',
}
```

### Configuring shared authentication credentials

To perform LDAP authentication and file authorization following code can be used.

```puppet
class { 'rundeck':
  auth_types  => ['ldap_shared'],
  auth_config => {
    'file' => {
      'auth_users' => [
        {
          'username' => 'rooty',
          'roles'    => ['admin'],
        },
        {
          'username' => 'stan',
          'roles'    => ['sre'],
        }
      ],
    },
    'ldap' => {
      'url'                            => 'ldap://ldap:389',
      'force_binding'                  => true,
      'bind_dn'                        => 'cn=ProxyUser,dc=example,dc=com',
      'bind_password'                  => 'secret',
      'user_base_dn'                   => 'ou=Users,dc=example,dc=com',
      'user_rdn_attribute'             => 'uid',
      'user_id_attribute'              => 'uid',
      'user_object_class'              => 'inetOrgPerson',
      'role_base_dn'                   => 'ou=Groups,dc=example,dc=com',
      'role_name_attribute'            => 'cn',
      'role_member_attribute'          => 'memberUid',
      'role_username_member_attribute' => 'memberUid',
      'role_object_class'              => 'posixGroup',
      'supplemental_roles'             => 'user',
      'nested_groups'                  => false,
    },
  },
}
```

## Reference

See [REFERENCE.md](https://github.com/voxpupuli/puppet-rundeck/blob/master/REFERENCE.md)

## Limitations

This module is tested on the following platforms:

- CentOS 6
- CentOS 7
- Debian 8
- RedHat 8
- Ubuntu 16.04

It is tested with the OSS version of Puppet only.

## Development

### Contributing

This module is maintained by [Vox Pupuli](https://voxpupuli.org/). Vox Pupuli
welcomes new contributions to this module, especially those that include
documentation and rspec tests. We are happy to provide guidance if necessary.

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for more details.
