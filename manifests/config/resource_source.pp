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
define rundeck::config::resource_source (
  $directory           = $rundeck::default_resource_dir,
  $group               = $rundeck::group,
  $include_server_node = $rundeck::include_server_node,
  $mapping_params      = '',
  $number              = 1,
  $projects_dir        = $rundeck::projects_dir,
  $project_name        = undef,
  $resource_format     = $rundeck::resource_format,
  $running_only        = true,
  $script_args         = '',
  $script_args_quoted  = $rundeck::script_args_quoted,
  $script_file         = '',
  $script_interpreter  = $rundeck::script_interpreter,
  $source_type         = $rundeck::default_source_type,
  $url                 = '',
  $url_cache           = $rundeck::url_cache,
  $url_timeout         = $rundeck::url_timeout,
  $use_default_mapping = true,
  $user                = $rundeck::user,
) {

  include ::rundeck

  validate_string($project_name)
  validate_integer($number)
  validate_re($source_type, ['^file$', '^directory$', '^url$', '^script$', '^aws-ec2$'])
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

  Ini_setting {
    ensure  => present,
    path    => $properties_file,
    section => '',
    require => File[$properties_file],
  }

  ini_setting { "${name}::resources.source.${number}.type":
    setting => "resources.source.${number}.type",
    value   => $source_type,
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
        setting => "resources.source.${number}.config.requireFileExists",
        value   => bool2str(true),
      }

      ini_setting { "${name}::resources.source.${number}.config.includeServerNode":
        setting => "resources.source.${number}.config.includeServerNode",
        value   => bool2str($include_server_node),
      }

      ini_setting { "${name}::resources.source.${number}.config.generateFileAutomatically":
        setting => "resources.source.${number}.config.generateFileAutomatically",
        value   => bool2str(true),
      }

      ini_setting { "${name}::resources.source.${number}.config.format":
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
      }

      ini_setting { "${name}::resources.source.${number}.config.file":
        setting => "resources.source.${number}.config.file",
        value   => $file,
      }
    }
    'url': {

      validate_string($url)
      validate_integer($url_timeout)
      validate_bool($url_cache)

      ini_setting { "${name}::resources.source.${number}.config.url":
        setting => "resources.source.${number}.config.url",
        value   => $url,
      }

      ini_setting { "${name}::resources.source.${number}.config.timeout":
        setting => "resources.source.${number}.config.timeout",
        value   => $url_timeout,
      }

      ini_setting { "${name}::resources.source.${number}.config.cache":
        setting => "resources.source.${number}.config.cache",
        value   => bool2str($url_cache),
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
        setting => "resources.source.${number}.config.directory",
        value   => $directory,
      }
    }
    'script': {
      validate_re($resource_format, ['^resourcexml$','^resourceyaml$'])
      validate_bool($script_args_quoted)
      validate_string($script_interpreter)
      validate_absolute_path($script_file)
      validate_string($script_args)

      ini_setting { "${name}::resources.source.${number}.config.file":
        setting => "resources.source.${number}.config.file",
        value   => $script_file,
      }

      ini_setting { "${name}::resources.source.${number}.config.args":
        setting => "resources.source.${number}.config.args",
        value   => $script_args,
      }

      ini_setting { "${name}::resources.source.${number}.config.format":
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
      }

      ini_setting { "${name}::resources.source.${number}.config.interpreter":
        setting => "resources.source.${number}.config.interpreter",
        value   => $script_interpreter,
      }

      ini_setting { "${name}::resources.source.${number}.config.argsQuoted":
        setting => "resources.source.${number}.config.argsQuoted",
        value   => bool2str($script_args_quoted),
      }
    }
    'aws-ec2': {
      ini_setting { "resources.source.${number}.config.mappingParams":
        setting => "resources.source.${number}.config.mappingParams",
        value   => $mapping_params,
      }
      ini_setting { "resources.source.${number}.config.useDefaultMapping":
        setting => "resources.source.${number}.config.useDefaultMapping",
        value   => bool2str($use_default_mapping),
      }
      ini_setting { "resources.source.${number}.config.runningOnly":
        setting => "resources.source.${number}.config.runningOnly",
        value   => bool2str($running_only),
      }
    }
    default: {
      err("The rundeck resource model source_type ${source_type} is not supported")
    }
  }
}
