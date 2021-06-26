# == Class rundeck::jobs
#
# This private class is called from `rundeck` to create Rundeck jobs
# It is separate from rundeck::config to avoid service restarts.
#

class rundeck::jobs {

  # pre-create directory to hold job definitions
  $jobs_dir = "${rundeck::rdeck_home}/jobs"
  ensure_resource(file, $jobs_dir, {'ensure' => 'directory'})

  # create jobs
  create_resources(rundeck::config::job, $rundeck::jobs)

}

