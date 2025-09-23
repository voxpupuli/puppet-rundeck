# @summary This define will manage projects and jobs.
#
# @example Basic usage.
#   rundeck::config::project { 'MyProject':
#     config => {
#       'project.description'      => 'My test project',
#       'project.disable.schedule' => 'false',
#     },
#   }
#
# @example Advanced usage with jobs.
#   rundeck::config::project { 'MyProject':
#     config => {
#       'project.description'      => 'My test project',
#       'project.disable.schedule' => 'false',
#     },
#     jobs   => {
#       'MyJob1' => {
#         'path'   => '/etc/myjob1',
#         'format' => 'yaml',
#       },
#       'MyJob2' => {
#         'path'   => '/etc/myjob2',
#         'format' => 'xml',
#       },
#       'DeleteJob1' => {
#         'ensure' => 'absent',
#         'path'   => '/etc/testjob1',
#         'format' => 'yaml',
#       },
#     },
#   }
#
# @example Advanced usage with scm_config.
#   rundeck::config::project { 'MyProject':
#     config     => {
#       'project.description'      => 'My test project',
#       'project.disable.schedule' => 'false',
#     },
#     scm_config => {
#       'import' => {
#         'type'   => 'git-import',
#         'config' => {
#           'strictHostKeyChecking' => 'yes',
#           'gitPasswordPath'       => 'keys/example-access-token',
#           'format'                => 'xml',
#           'dir'                   => '/var/lib/rundeck/projects/MyProject/ScmImport',
#           'branch'                => 'master',
#           'url'                   => 'https://myuser@example.com/example/example.git',
#           'filePattern'           => '*.xml',
#           'useFilePattern'        => 'true',
#           'pathTemplate'          => "\${job.id}.\${config.format}",
#           'importUuidBehavior'    => 'preserve',
#           'sshPrivateKeyPath'     => '',
#           'fetchAutomatically'    => 'true',
#           'pullAutomatically'     => 'true',
#         },
#       },
#     },
#   }
#
# @param ensure
#   Whether or not the project should be present.
# @param config
#   Configuration properties for a project.
# @param update_method
#   set: Overwrite all configuration properties for a project. Any config keys not included will be removed.
#   update: Modify configuration properties for a project. Only the specified keys will be updated.
# @param jobs
#   Rundeck jobs related to a project.
# @param owner
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param projects_dir
#   Directory where some project config will be stored.
# @param scm_config
#   A hash of name value pairs representing properties for the scm.json file.
#
define rundeck::config::project (
  Enum['absent', 'present'] $ensure = 'present',
  Hash[String, String] $config = {
    'project.description'                                 => "${name} project",
    'project.label'                                       => $name,
    'project.disable.executions'                          => 'false',
    'project.disable.schedule'                            => 'false',
    'project.execution.history.cleanup.batch'             => '500',
    'project.execution.history.cleanup.enabled'           => 'true',
    'project.execution.history.cleanup.retention.days'    => '60',
    'project.execution.history.cleanup.retention.minimum' => '50',
    'project.execution.history.cleanup.schedule'          => '0 0 0 1/1 * ? *',
    'project.jobs.gui.groupExpandLevel'                   => '1',
  },
  Enum['set', 'update'] $update_method = 'update',
  Hash[String, Rundeck::Job] $jobs = {},
  String[1] $owner = 'rundeck',
  String[1] $group = 'rundeck',
  Stdlib::Absolutepath $projects_dir = '/var/lib/rundeck/projects',
  Optional[Rundeck::Scm] $scm_config = undef,
) {
  require rundeck::cli

  $_default_cfg = {
    'project.name' => $name,
  }

  $_final_cfg = $config + $_default_cfg

  $_cmd_line_cfg = $_final_cfg.map |$_k, $_v| {
    "--${_k}=${_v}"
  }

  $_project_diff = $update_method ? {
    'set'   => "rd_project_diff.sh '${name}' ${update_method} '${_final_cfg.to_json}'",
    default => "rd_project_diff.sh '${name}' ${update_method} '${_final_cfg.to_json}' '${_final_cfg.keys}'",
  }

  if $ensure == 'absent' {
    exec { "Remove rundeck project: ${name}":
      command     => "rd projects delete -y -p '${name}'",
      path        => ['/bin', '/usr/bin', '/usr/local/bin'],
      environment => $rundeck::cli::environment,
      onlyif      => "rd projects info -p '${name}'",
    }
  } else {
    exec {
      default:
        path        => ['/bin', '/usr/bin', '/usr/local/bin'],
        environment => $rundeck::cli::environment,
      ;
      "Create rundeck project: ${name}":
        command => "rd projects create -p '${name}' -- ${_cmd_line_cfg.shellquote}",
        unless  => "rd projects info -p '${name}'",
      ;
      "Manage rundeck project: ${name}":
        command => "rd projects configure ${update_method} -p '${name}' -- ${_cmd_line_cfg.shellquote}",
        unless  => $_project_diff,
      ;
    }

    $jobs.each |$_name, $_attr| {
      if $_attr['ensure'] == 'absent' {
        exec { "(${name}) Remove job: ${_name}":
          command     => "rd jobs purge -y -p '${name}' -J '${_name}'",
          path        => ['/bin', '/usr/bin', '/usr/local/bin'],
          environment => $rundeck::cli::environment,
          onlyif      => "rd jobs list -p '${name}' -J '${_name}' | grep -q '${_name}'",
        }
      } else {
        exec { "(${name}) Create/update job: ${_name}":
          command     => "rd jobs load -d update -p '${name}' -f '${_attr['path']}' -F ${_attr['format']}",
          path        => ['/bin', '/usr/bin', '/usr/local/bin'],
          environment => $rundeck::cli::environment,
          unless      => "rd_job_diff.sh '${name}' '${_name}' '${_attr['path']}' ${_attr['format']}",
        }
      }
    }

    if $scm_config {
      ensure_resource('file', "${projects_dir}/${name}",
        {
          'ensure' => 'directory',
          'owner' => $owner,
          'group' => $group,
          'mode' => '0755'
        }
      )

      $scm_config.each |$integration, $config| {
        file { "${projects_dir}/${name}/scm-${integration}.json":
          ensure  => file,
          owner   => $owner,
          group   => $group,
          mode    => '0644',
          content => stdlib::to_json($config),
        }

        $_command = [
          'rd projects scm setup',
          "-p '${name}'",
          "-i ${integration}",
          "-t ${config['type']}",
          "-f ${projects_dir}/${name}/scm-${integration}.json",
        ].join(' ')

        $_unless = [
          "rd projects scm status -p '${name}' -i ${integration} | grep -q .",
          "rd_scm_diff.sh ${projects_dir} '${name}' ${integration}",
        ].join(' && ')

        exec { "Setup/update/enable SCM ${integration} for rundeck project: ${name}":
          command     => $_command,
          path        => ['/bin', '/usr/bin', '/usr/local/bin'],
          environment => $rundeck::cli::environment,
          unless      => $_unless,
          require     => File["${projects_dir}/${name}/scm-${integration}.json"],
        }
      }
    }
  }
}
