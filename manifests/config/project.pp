# @api private
#
# @summary This private class is called from rundeck::config used to manage the default project properties.
#
class rundeck::config::project {
  assert_private()

  $_project_config = deep_merge(lookup('rundeck::project_config'), $rundeck::project_config)

  file { "${rundeck::config::properties_dir}/project.properties":
    ensure  => file,
    content => epp('rundeck/project.properties.epp', { _project_config => $_project_config }),
    require => File[$rundeck::config::properties_dir],
  }
}
