# @summary This define will install a rundeck plugin.
#
# @example Basic usage.
#   rundeck::config::plugin { 'rundeck-hipchat-plugin-1.0.0.jar':
#     source => 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar',
#   }
#
# @param ensure
#   Set present or absent to add or remove the plugin
# @param source
#   The http source or local path from which to get the plugin.
# @param plugins_dir
#   Directory where plugins will be installed.
# @param proxy_server
#   Get the plugin trough a proxy server.
#
define rundeck::config::plugin (
  String                    $source,
  Enum['present', 'absent'] $ensure       = 'present',
  Stdlib::Absolutepath      $plugins_dir  = '/var/lib/rundeck/libext',
  Optional[Stdlib::HTTPUrl] $proxy_server = undef,
) {
  ensure_resource('file', $plugins_dir, { 'ensure' => 'directory', 'mode' => '0755' })

  if $ensure == 'present' {
    archive { "download plugin ${name}":
      ensure       => present,
      source       => $source,
      path         => "${plugins_dir}/${name}",
      proxy_server => $proxy_server,
      before       => File["${plugins_dir}/${name}"],
    }
  }

  file { "${plugins_dir}/${name}":
    ensure => $ensure,
    mode   => '0644',
  }
}
