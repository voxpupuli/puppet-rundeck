# @summary This define will create and manage a rundeck project.
#
# @example Basic usage.
#   rundeck::config::project { 'MyProject':
#     config => {
#       'project.description'      => 'My test project',
#       'project.disable.schedule' => 'false',
#     },
#   }
#
# @param config
#   Configuration properties for a project.
# @param update_method
#   set: Overwrite all configuration properties for a project. Any config keys not included will be removed.
#   update: Modify configuration properties for a project. Only the specified keys will be updated.
# @param jobs
#   Rundeck jobs related to a project.
#
define rundeck::config::project (
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
) {
  include rundeck::cli

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

  exec {
    default:
      path        => ['/bin', '/usr/bin', '/usr/local/bin'],
      environment => $rundeck::cli::environment,
      ;
    "Create rundeck project: ${name}":
      command => "rd projects create -p ${name}",
      unless  => "rd projects info -p ${name}",
      ;
    "Manage rundeck project: ${name}":
      command => "rd projects configure ${update_method} -p ${name} -- ${_cmd_line_cfg.shellquote}",
      unless  => $_project_diff,
      ;
  }

  $jobs.each |$_name, $_attr| {
    if $_attr['ensure'] == 'absent' {
      exec { "Remove rundeck job: ${_name}":
        command     => "rd jobs purge -y -p '${name}' -J '${_name}'",
        path        => ['/bin', '/usr/bin', '/usr/local/bin'],
        environment => $rundeck::cli::environment,
        onlyif      => "rd jobs list -p '${name}' -J '${_name}' | grep -q '${_name}'",
      }
    } else {
      exec { "Create/update rundeck job: ${_name}":
        command     => "rd jobs load -d update -p '${name}' -f '${_attr['path']}' -F ${_attr['format']}",
        path        => ['/bin', '/usr/bin', '/usr/local/bin'],
        environment => $rundeck::cli::environment,
        unless      => "rd_job_diff.sh '${name}' '${_name}' '${_attr['path']}' ${_attr['format']}",
      }
    }
  }
}
