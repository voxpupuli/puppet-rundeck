# @api private
#
# @summary This private class is called from rundeck::config used to manage the rundeck-config properties.
#
class rundeck::config::rundeck {
  assert_private()

  $_service_notify = $rundeck::service_notify ? {
    false => undef,
    default => Service[$rundeck::service_name]
  }

  file { "${rundeck::config::properties_dir}/rundeck-config.properties":
    ensure  => file,
    content => epp($rundeck::config_template),
    require => File[$rundeck::config::properties_dir],
    notify  => $_service_notify,
  }
}
