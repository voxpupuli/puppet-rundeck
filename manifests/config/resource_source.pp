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
# [*user*]
#   The user that rundeck is installed as.
#
# [*group*]
#   The group permission that rundeck is installed as.
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
  $project_name,
  $framework_config    = {},
  $number              = '',
  $source_type         = '',
  $file                = '',
  $include_server_node = '',
  $resource_format     = '',
  $url                 = '',
  $url_timeout         = '',
  $url_cache           = '',
  $directory           = '',
  $script_file         = '',
  $script_args         = '',
  $script_args_quoted  = '',
  $script_interpreter  = '',
  $projects_dir        = '',
  $user                = '',
  $group               = ''
) {

  include rundeck::params

  $framework_properties = deep_merge($rundeck::params::framework_config, $framework_config)

  if "x${number}x" == 'xx' {
    $num = '1'
  } else {
    $num = $number
  }

  if "x${source_type}x" == 'xx' {
    $type = $rundeck::params::default_source_type
  } else {
    $type = $source_type
  }

  if "x${include_server_node}x" == 'xx' {
    $inc_server = $rundeck::params::include_server_node
  } else {
    $inc_server = $include_server_node
  }

  if "x${resource_format}x" == 'xx' {
    $format = $rundeck::params::resource_format
  } else {
    $format = $resource_format
  }

  if "x${url_timeout}x" == 'xx' {
    $timeout = $rundeck::params::url_timeout
  } else {
    $timeout = $url_timeout
  }

  if "x${url_cache}x" == 'xx' {
    $cache = $rundeck::params::url_cache
  } else {
    $cache = $url_cache
  }

  if "x${directory}x" == 'xx' {
    $dir = $rundeck::params::default_resource_dir
  } else {
    $dir = $directory
  }

  if "x${projects_dir}x" == 'xx' {
    $pd = $framework_properties['framework.projects.dir']
  } else {
    $pd = $projects_dir
  }

  if "x${script_args_quoted}x" == 'xx' {
    $saq = $rundeck::params::script_args_quoted
  } else {
    $saq = $script_args_quoted
  }

  if "x${script_interpreter}x" == 'xx' {
    $sci = $rundeck::params::script_interpreter
  } else {
    $sci = $script_interpreter
  }

  if "x${file}x" == 'xx' {
    $f = "${pd}/${project_name}/etc/resources.xml"
  } else {
    $f = $file
  }

  if "x${user}x" == 'xx' {
    $u = $rundeck::params::user
  } else {
    $u = $user
  }

  if "x${group}x" == 'xx' {
    $g = $rundeck::params::group
  } else {
    $g = $group
  }

  validate_string($project_name)
  validate_re($num, '[1-9]*')
  validate_re($type, ['^file$', '^directory$', '^url$', '^script$'])
  validate_bool($inc_server)
  validate_absolute_path($pd)
  validate_re($u, '[a-zA-Z0-9]{3,}')
  validate_re($g, '[a-zA-Z0-9]{3,}')

  ensure_resource('file', "${pd}/${project_name}", {'ensure' => 'directory', 'owner' => $u, 'group' => $g} )
  ensure_resource('file', "${pd}/${project_name}/etc", {'ensure' => 'directory', 'owner' => $u, 'group' => $g, 'require' => File["${pd}/${project_name}"]} )

  $properties_dir  = "${pd}/${project_name}/etc"
  $properties_file = "${properties_dir}/project.properties"

  file { $properties_file:
    ensure  => present,
    owner   => $u,
    group   => $g,
    mode    => '0640',
    require => File[$properties_dir]
  }

  ini_setting { "resources.source.${num}.type":
    ensure  => present,
    path    => $properties_file,
    section => '',
    setting => "resources.source.${num}.type",
    value   => $type,
    require => File[$properties_file]
  }

  case downcase($type) {
    'file': {
      validate_re($format, ['^resourcexml$','^resourceyaml$'])

      ini_setting { "resources.source.${num}.config.requireFileExists":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.requireFileExists",
        value   => true,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.includeServerNode":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.includeServerNode",
        value   => $inc_server,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.generateFileAutomatically":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.generateFileAutomatically",
        value   => true,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.format",
        value   => $format,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.file",
        value   => $f,
        require => File[$properties_file]
      }
    }
    'url': {

      validate_string($url)
      validate_re($timeout, '[0-9]*')
      validate_bool($cache)

      ini_setting { "resources.source.${num}.config.url":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.url",
        value   => $url,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.timeout":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.timeout",
        value   => $timeout,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.cache":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.cache",
        value   => $cache,
        require => File[$properties_file]
      }
    }
    'directory': {
      validate_absolute_path($dir)

      ini_setting { "resources.source.${num}.config.directory":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.directory",
        value   => $directory,
        require => File[$properties_file]
      }
    }
    'script': {
      validate_re($format, ['^resourcexml$','^resourceyaml$'])
      validate_bool($saq)
      validate_string($sci)
      validate_absolute_path($script_file)
      validate_string($script_args)

      ini_setting { "resources.source.${num}.config.file":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.file",
        value   => $script_file,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.args":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.args",
        value   => $script_args,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.format":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.format",
        value   => $format,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.interpreter":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.interpreter",
        value   => $sci,
        require => File[$properties_file]
      }

      ini_setting { "resources.source.${num}.config.argsQuoted":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${num}.config.argsQuoted",
        value   => $saq,
        require => File[$properties_file]
      }
    }
    default: {
      err("The rundeck resource model type: ${type} is not supported")
    }
  }
}
