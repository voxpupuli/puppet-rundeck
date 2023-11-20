# @api private
#
# @summary This private class is called from rundeck::config used to manage the framework properties of rundeck.
#
class rundeck::config::framework {
  if $rundeck::ssl_enabled {
    $_ssl_conig = {
      'framework.server.port' => $rundeck::ssl_port,
      'framework.server.url'  => "https://${rundeck::framework_config['framework.server.name']}:${rundeck::ssl_port}",
    }
  } else {
    $_ssl_config = {}
  }

  $_framework_config = merge($rundeck::framework_config, $_ssl_config)

  file { "${rundeck::config::properties_dir}/framework.properties":
    ensure  => file,
    content => epp('rundeck/framework.properties.epp', { framework_config => $_framework_config }),
    owner   => $rundeck::user,
    group   => $rundeck::group,
    require => File[$rundeck::config::properties_dir],
  }
}
