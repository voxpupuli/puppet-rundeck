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
# [*project_name*]
#   The name of the project for which this resource in intended to be a part.
#
# [*number*]
#   The sequential number of the resource within the project.
#
# [*source_type*]
#   The source type where resources will come from: file, directory, url or script.
#
# [*file*]
#   When a file source_type is specified this is the path to that file.
#
# [*include_server_node*]
#   Boolean value to decide whether or not to include the server node in your list of avaliable nodes.
#
# [*resource_format*]
#   The format of the resource that will procesed, either resourcexml or resourceyaml.
#
# [*url*]
#   When the url source_type is specified this is the path to that url.
#
# [*url_timeout*]
#   An integer value in seconds that rundeck will wait for resources from the url before timing out.
#
# [*url_cache*]
#   Boolean value. Keep a local cache of the resources pulled from the url.
#
# [*directory*]
#   When the directory source_type is specified this is the path to that directory.
#
# [*script_file*]
#   When the script source_type is specified this is the path that that script.
#
# [*script_args*]
#   A string of the full arguments to pass the the specified script.
#
# [*script_args_quoted*]
#   Boolean value. Quote the arguments of the script.
#
# [*script_interpreter*]
#   The interpreter to use in executing the script. Defaults to: '/bin/bash'
#
# [*projects_dir*]
#   The directory where rundeck is configured to store project information.
#
# === Examples
#
# Manage a file resource:
#
# rundeck::config::resource_source { 'nodes from file':
#   project_name        => 'test project',
#   number              => '1',
#   source_type         => 'file',
#   file                => '/var/lib/rundeck/etc/resources.yaml',
#   include_server_node => false,
#   resource_format     => 'resourceyaml',
# }
#
define rundeck::config::resource_source(
  $project_name        = undef,
  $number              = '1',
  $source_type         = $rundeck::params::default_source_type,
  $include_server_node = $rundeck::params::include_server_node,
  $resource_format     = $rundeck::params::resource_format,
  $url                 = '',
  $url_timeout         = $rundeck::params::url_timeout,
  $url_cache           = $rundeck::params::url_cache,
  $directory           = $rundeck::params::default_resource_dir,
  $script_file         = '',
  $script_args         = '',
  $script_args_quoted  = $rundeck::params::script_args_quoted,
  $script_interpreter  = $rundeck::params::script_interpreter,
) {

  include rundeck

  $framework_properties = deep_merge($rundeck::params::framework_config, $::rundeck::framework_config)

  $projects_dir = $framework_properties['framework.projects.dir']
  $user = $::rundeck::user
  $group = $::rundeck::group

  if $project_name == undef {
    fail('project_name must be specified')
  }

  validate_string($project_name)
  validate_re($number, '[1-9]*')
  validate_re($source_type, ['^file$', '^directory$', '^url$', '^script$'])
  validate_bool($include_server_node)
  validate_absolute_path($projects_dir)
  validate_re($user, '[a-zA-Z0-9]{3,}')
  validate_re($group, '[a-zA-Z0-9]{3,}')

  ensure_resource('file', "${projects_dir}/${project_name}", {'ensure' => 'directory', 'owner' => $user, 'group' => $group} )
  ensure_resource('file', "${projects_dir}/${project_name}/etc", {'ensure' => 'directory', 'owner' => $user, 'group' => $group, 'require' => File["${projects_dir}/${project_name}"]} )

  $properties_dir  = "${projects_dir}/${project_name}/etc"
  $properties_file = "${properties_dir}/project.properties"

  ini_setting { "resources.source.${number}.type":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => "resources.source.${number}.type",
    value   => $source_type,
    require => File[$properties_file]
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
      }

      $file = "${properties_dir}/${name}.${file_extension}"

      ini_setting { "resources.source.${number}.config.requireFileExists":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.requireFileExists",
        value   => true,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.includeServerNode":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.includeServerNode",
        value   => $include_server_node,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.generateFileAutomatically":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.generateFileAutomatically",
        value   => true,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.file",
        value   => $file,
        require => File[$properties_file]
      }
    }
    'url': {

      validate_string($url)
      validate_re($url_timeout, '[0-9]*')
      validate_bool($url_cache)

      ini_setting { "resources.source.${number}.config.url":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.url",
        value   => $url,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.timeout":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.timeout",
        value   => $url_timeout,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.cache":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.cache",
        value   => $url_cache,
        require => File[$properties_file]
      }
    }
    'directory': {
      validate_absolute_path($directory)

      file { $directory:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => 0740,
      }

      ini_setting { "resources.source.${number}.config.directory":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.directory",
        value   => $directory,
        require => File[$properties_file]
      }
    }
    'script': {
      validate_re($resource_format, ['^resourcexml$','^resourceyaml$'])
      validate_bool($script_args_quoted)
      validate_string($script_interpreter)
      validate_absolute_path($script_file)
      validate_string($script_args)

      ini_setting { "resources.source.${number}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.file",
        value   => $script_file,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.args":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.args",
        value   => $script_args,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.format",
        value   => $resource_format,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.interpreter":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.interpreter",
        value   => $script_interpreter,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${number}.config.argsQuoted":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.argsQuoted",
        value   => $script_args_quoted,
        require => File[$properties_file]
      }
    }
    default: {
      err("The rundeck resource model source_type ${source_type} is not supported")
    }
  }
}
