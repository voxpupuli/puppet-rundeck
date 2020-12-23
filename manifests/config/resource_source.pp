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
# [*assume_role_arn*]
#   When using the aws-ec2 source_type, this specifies the assume role ARN parameter.
# [*directory*]
#   When the directory source_type is specified this is the path to that directory.
#
# [*endpoint_url*]
#   The API AWS endpoint.
#
# [*filter_tag*]
#   String value for using tags.
#
# [*http_proxy_port*]
#   An integer value that defines the http proxy port.
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
# [*refresh_interval*]
#   How often the data will be updated.
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
  Stdlib::Absolutepath $directory                                = $rundeck::params::default_resource_dir,
  Boolean $include_server_node                                   = $rundeck::params::include_server_node,
  String $mapping_params                                         = '',
  Integer $number                                                = 1,
  Optional[String] $project_name                                 = undef,
  Enum['resourcexml', 'resourceyaml'] $resource_format           = $rundeck::params::resource_format,
  Boolean $running_only                                          = true,
  String $script_args                                            = '',
  Boolean $script_args_quoted                                    = $rundeck::params::script_args_quoted,
  Optional[Stdlib::Absolutepath] $script_file                    = undef,
  String $script_interpreter                                     = $rundeck::params::script_interpreter,
  Rundeck::Sourcetype $source_type                               = $rundeck::params::default_source_type,
  String $url                                                    = '',
  Boolean $url_cache                                             = $rundeck::params::url_cache,
  Integer $url_timeout                                           = $rundeck::params::url_timeout,
  Boolean $use_default_mapping                                   = true,
  Optional[String] $endpoint_url                                 = undef,
  Optional[String[1]] $assume_role_arn                           = undef,
  String $filter_tag                                             = '',
  Stdlib::Port $http_proxy_port                                  = $rundeck::params::default_http_proxy_port,
  Integer $refresh_interval                                      = $rundeck::params::default_refresh_interval,
  Integer $page_results                                          = $rundeck::params::default_page_results,
  Optional[String] $puppet_enterprise_host                       = undef,
  Optional[Stdlib::Port] $puppet_enterprise_port                 = undef,
  Optional[Stdlib::Absolutepath] $puppet_enterprise_ssl_dir      = undef,
  Optional[String] $puppet_enterprise_certificate_name           = undef,
  Optional[Stdlib::Absolutepath] $puppet_enterprise_mapping_file = undef,
  Optional[Integer] $puppet_enterprise_metrics_interval          = undef,
  Optional[String] $puppet_enterprise_node_query                 = undef,
  Optional[String] $puppet_enterprise_default_node_tag           = undef,
  Optional[String] $puppet_enterprise_tag_source                 = undef,
) {
  include rundeck

  $framework_properties = deep_merge($rundeck::params::framework_config, $rundeck::framework_config)

  $projects_dir = $framework_properties['framework.projects.dir']
  $user = $rundeck::user
  $group = $rundeck::group

  if $project_name == undef {
    fail('project_name must be specified')
  }

  assert_type(Stdlib::Absolutepath, $projects_dir)

  ensure_resource('file', "${projects_dir}/${project_name}", {
      'ensure' => 'directory',
      'owner'  => $user,
      'group'  => $group
  })
  ensure_resource('file', "${projects_dir}/${project_name}/etc", {
      'ensure'  => 'directory',
      'owner'   => $user,
      'group'   => $group,
      'require' => File["${projects_dir}/${project_name}"]
  })

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
      ini_setting { "${name}::resources.source.${number}.config.mappingParams":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.mappingParams",
        value   => $mapping_params,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.useDefaultMapping":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.useDefaultMapping",
        value   => bool2str($use_default_mapping),
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.runningOnly":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.runningOnly",
        value   => bool2str($running_only),
        require => File[$properties_file],
      }
      # endpoint is an optional field that must be omitted if empty
      if ($endpoint_url) {
        ini_setting { "${name}::resources.source.${number}.config.endpoint":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.endpoint",
          value   => $endpoint_url,
          require => File[$properties_file],
        }
      }
      # assumeRoleArn is an optional field that must be omitted if empty
      if ($assume_role_arn) {
        ini_setting { "${name}::resources.source.${number}.config.assumeRoleArn":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.assumeRoleArn",
          value   => $assume_role_arn,
          require => File[$properties_file],
        }
      }
      ini_setting { "${name}::resources.source.${number}.config.filter":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.filter",
        value   => $filter_tag,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.httpProxyPort":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.httpProxyPort",
        value   => $http_proxy_port,
        require => File[$properties_file],
      }
      ini_setting { "${name}::resources.source.${number}.config.refreshInterval":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.refreshInterval",
        value   => $refresh_interval,
        require => File[$properties_file],
      }
      # pageResults is a required field and must be numeric
      ini_setting { "${name}::resources.source.${number}.config.pageResults":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.pageResults",
        value   => $page_results,
        require => File[$properties_file],
      }
    }
    'puppet-enterprise': {
      if ( $puppet_enterprise_mapping_file ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_MAPPING_FILE":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_MAPPING_FILE",
          value   => $puppet_enterprise_mapping_file,
          require => File[$properties_file],
        }
      }
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_HOST":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_HOST",
        value   => $puppet_enterprise_host,
        require => File[$properties_file],
      }
      if ( $puppet_enterprise_metrics_interval ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_METRICS_INTERVAL":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_METRICS_INTERVAL",
          value   => $puppet_enterprise_metrics_interval,
          require => File[$properties_file],
        }
      }
      ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_PORT":
        ensure  => present,
        path    => $properties_file,
        section => '',
        setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_PORT",
        value   => $puppet_enterprise_port,
        require => File[$properties_file],
      }
      if ( $puppet_enterprise_ssl_dir ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_SSL_DIR":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_SSL_DIR",
          value   => $puppet_enterprise_ssl_dir,
          require => File[$properties_file],
        }
      }
      if ( $puppet_enterprise_certificate_name ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_PUPPETDB_CERTIFICATE_NAME":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_PUPPETDB_CERTIFICATE_NAME",
          value   => $puppet_enterprise_certificate_name,
          require => File[$properties_file],
        }
      }
      if $puppet_enterprise_node_query {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_NODE_QUERY":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_NODE_QUERY",
          value   => $puppet_enterprise_node_query,
          require => File[$properties_file],
        }
      }
      if ( $puppet_enterprise_default_node_tag ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_DEFAULT_NODE_TAG":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_DEFAULT_NODE_TAG",
          value   => $puppet_enterprise_default_node_tag,
          require => File[$properties_file],
        }
      }
      if ( $puppet_enterprise_tag_source ) {
        ini_setting { "${name}::resources.source.${number}.config.PROPERTY_TAGS_SOURCE":
          ensure  => present,
          path    => $properties_file,
          section => '',
          setting => "resources.source.${number}.config.PROPERTY_TAGS_SOURCE",
          value   => $puppet_enterprise_tag_source,
          require => File[$properties_file],
        }
      }
    }
    default: {
      err("The rundeck resource model source_type ${source_type} is not supported")
    }
  }
}
