# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define rundeck::config::resource_source
#
# This definition is called from rundeck::config::project and is used to
# create a resource sources that gather node information.
#
# === Parameters
#
# [*directory*]
#   When the directory source_type is specified this is the path to that directory.
#
# [*include_server_node*]
#   Boolean value to decide whether or not to include the server node in your list of avaliable nodes.
#
# [*number*]
#   The sequential number of the resource within the project.
#
# [*project_name*]
#   The name of the project for which this resource in intended to be a part.
#
# [*projects_dir*]
#   The directory where rundeck is configured to store project information.
#
# [*resource_format*]
#   The format of the resource that will procesed, either resourcexml or resourceyaml.
#
# [*script_args*]
#   A string of the full arguments to pass the the specified script.
#
# [*script_args_quoted*]
#   Boolean value. Quote the arguments of the script.
#
# [*script_file*]
#   When the script source_type is specified this is the path that that script.
#
# [*script_interpreter*]
#   The interpreter to use in executing the script. Defaults to: '/bin/bash'
#
# [*source_type*]
#   The source type where resources will come from: file, directory, url or script.
#
# [*url*]
#   When the url source_type is specified this is the path to that url.
#
# [*url_cache*]
#   Boolean value. Keep a local cache of the resources pulled from the url.
#
# [*url_timeout*]
#   An integer value in seconds that rundeck will wait for resources from the url before timing out.
#
# === Examples
#
# Manage a file resource:
#
# rundeck::config::resource_source { 'resource':
#   project_name        => 'myproject',
#   number              => '1',
#   source_type         => 'file',
#   include_server_node => false,
#   resource_format     => 'resourceyaml',
# }
#
define rundeck::config::resource_source(
  $directory                          = $rundeck::params::default_resource_dir,
  $include_server_node                = $rundeck::params::include_server_node,
  $mapping_params                     = '',
  $number                             = '1',
  $project_name                       = undef,
  $resource_format                    = $rundeck::params::resource_format,
  $running_only                       = true,
  $script_args                        = '',
  $script_args_quoted                 = $rundeck::params::script_args_quoted,
  $script_file                        = '',
  $script_interpreter                 = $rundeck::params::script_interpreter,
  $source_type                        = $rundeck::params::default_source_type,
  $url                                = '',
  $url_cache                          = $rundeck::params::url_cache,
  $url_timeout                        = $rundeck::params::url_timeout,
  $use_default_mapping                = true,
  $puppet_enterprise_host             = '',
  $puppet_enterprise_port             = '',
  $puppet_enterprise_mapping_file     = '',
  $puppet_enterprise_metrics_interval = '',
) {

  include ::rundeck

  $framework_properties = deep_merge($rundeck::params::framework_config, $::rundeck::framework_config)

  $projects_dir = $framework_properties['framework.projects.dir']
  $user = $::rundeck::user
  $group = $::rundeck::group

  if $project_name == undef {
    fail('project_name must be specified')
  }

  validate_string($project_name)
  validate_integer($number)
  validate_re($source_type, ['^file$', '^directory$', '^url$', '^script$', '^aws-ec2$', '^puppet-enterprise$'])
  validate_bool($include_server_node)
  validate_absolute_path($projects_dir)
  validate_re($user, '[a-zA-Z0-9]{3,}')
  validate_re($group, '[a-zA-Z0-9]{3,}')

  ensure_resource('file', "${projects_dir}/${project_name}", {
    'ensure' => 'directory',
    'owner'  => $user,
    'group'  => $group
  } )
  ensure_resource('file', "${projects_dir}/${project_name}/etc", {
    'ensure'  => 'directory',
    'owner'   => $user,
    'group'   => $group,
    'require' => File["${projects_dir}/${project_name}"]
  } )

  $properties_dir  = "${projects_dir}/${project_name}/etc"
  $properties_file = "${properties_dir}/project.properties"

  ini_setting { "${name}::resources.source.${number}.type":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => "resources.source.${number}.type",
    value   => $source_type,
    require => File[$properties_file],
  }

  case downcase($source_type) {
    'file': {
      validate_re($resource_format, ['^resourcexml$','^resourceyaml$'])

      case $resource_format {
        'resourcexml': {
          $file_extension = 'xml'
        }
        'resourceyaml': {
          $file_extension = 'yaml'
        }
        default: {
          err("The rundeck resource model resource_format ${resource_format} is not supported")
        }
      }

      $file = "${properties_dir}/${name}.${file_extension}"

      ini_setting { "${name}::resources.source.${number}.config.requireFileExists":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.requireFileExists",
        value   => bool2str(true),
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.includeServerNode":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.includeServerNode",
        value   => bool2str($include_server_node),
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.generateFileAutomatically":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.generateFileAutomatically",
        value   => bool2str(true),
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.file",
        value   => $file,
        require => File[$properties_file],
      }
    }
    'url': {
      validate_string($url)
      validate_integer($url_timeout)
      validate_bool($url_cache)

      ini_setting { "${name}::resources.source.${number}.config.url":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.url",
        value   => $url,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.timeout":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.timeout",
        value   => $url_timeout,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.cache":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.cache",
        value   => bool2str($url_cache),
        require => File[$properties_file],
      }
    }
    'directory': {
      validate_absolute_path($directory)

      file { $directory:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0740',
      }

      ini_setting { "${name}::resources.source.${number}.config.directory":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.directory",
        value   => $directory,
        require => File[$properties_file],
      }
    }
    'script': {
      validate_re($resource_format, ['^resourcexml$','^resourceyaml$'])
      validate_bool($script_args_quoted)
      validate_string($script_interpreter)
      validate_absolute_path($script_file)
      validate_string($script_args)

      ini_setting { "${name}::resources.source.${number}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.file",
        value   => $script_file,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.args":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.args",
        value   => $script_args,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.interpreter":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.interpreter",
        value   => $script_interpreter,
        require => File[$properties_file],
      }

      ini_setting { "${name}::resources.source.${number}.config.argsQuoted":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.argsQuoted",
        value   => bool2str($script_args_quoted),
        require => File[$properties_file],
      }
    }
    'aws-ec2': {
      ini_setting { "resources.source.${number}.config.mappingParams":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.mappingParams",
        value   => $mapping_params,
        require => File[$properties_file],
      }
      ini_setting { "resources.source.${number}.config.useDefaultMapping":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.useDefaultMapping",
        value   => bool2str($use_default_mapping),
        require => File[$properties_file],
      }
      ini_setting { "resources.source.${number}.config.runningOnly":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.runningOnly",
        value   => bool2str($running_only),
        require => File[$properties_file],
      }
    }
    'puppet-enterprise': {
      validate_string($puppet_enterprise_host)
      validate_integer($puppet_enterprise_port)
      validate_integer($puppet_enterprise_metrics_interval)
      validate_absolute_path($puppet_enterprise_mapping_file)
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_MAPPING_FILE":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_MAPPING_FILE",
        value   => $puppet_enterprise_mapping_file,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_HOST":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_HOST",
        value   => $puppet_enterprise_host,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_METRICS_INTERVAL":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_METRICS_INTERVAL",
        value   => $puppet_enterprise_metrics_interval,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_PORT":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_PORT",
        value   => $puppet_enterprise_port,
        require => File[$properties_file],
      }
    }
    default: {
      err("The rundeck resource model source_type ${source_type} is not supported")
    }
  }
}
