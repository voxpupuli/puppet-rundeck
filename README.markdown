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

[![Build
Status](https://secure.travis-ci.org/opentable/puppet-rundeck.png)](https://secure.travis-ci.org/opentable/puppet-rundeck.png)

##Module Description

This module provides a way to manage the installation and configuration of rundeck, it's projects, jobs and plugins.

##Setup

###What rundeck affects

* Installs OpenJDK-JRE (if not already installed by another module) as a prerequisite.
* Installs rundeck packages
* Manages configuration in /etc/rundeck and /var/lib/rundeck


###Beginning with rundeck

Installing rundeck:

```puppet
   class { 'rundeck': }
```

Installing rundeck with a custom jre:

```puppet
   class { 'rundeck':
     jre_name    => 'openjdk-7-jre',
     jre_version => '7u51-2.4.4-0ubuntu0.12.04.2'
   }
```

##Usage

###Classes and Defined Types

####Class: `rundeck`
The rundeck module primary class, guides the basic installation and management of rundeck on your system

**Parameters within `rundeck`:**
#####`package_version`
The version of rundeck that should be installed.

#####`jre_name`
The name of the jre to be installed if using a custom jre.

#####`jre_version`
The version of the jre to be installed if using a custom jre.

##Reference

###Classes
####Public Classes
* [`rundeck`](#class-rundeck): Guides the basic installation of rundeck
####Private Classes
* [`rundeck::install`](#class-rundeckinstall): Manages the installation of the rundeck packages
* [`rundeck::service`](#class-rundeckservice): Manages the rundeck service
* [`rundeck::config`](#class-rundeckconfig): Manages all the global configuration of the rundeck application

##Limitations

This module is tested on the following platforms:

* CentOS 6
* Ubuntu 12.04.2

It is tested with the OSS version of Puppet only.

##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.

###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker](https://github.com/puppetlabs/beaker) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
	BEAKER_DEBUG=yes bundle exec rspec spec/acceptance