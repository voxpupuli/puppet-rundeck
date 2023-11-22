# @api private
#
# @summary This private class is called from rundeck::config used to manage the ssl properties if ssl is enabled.
#
class rundeck::config::ssl {
  assert_private()

  file {
    "${rundeck::config::properties_dir}/ssl":
      ensure => directory,
      mode   => '0755',
      ;
    "${rundeck::config::properties_dir}/ssl/ssl.properties":
      ensure  => file,
      content => Sensitive(epp('rundeck/ssl.properties.epp')),
      mode    => '0400',
      ;
  }

  java_ks {
    default:
      ensure       => present,
      private_key  => $rundeck::ssl_private_key,
      certificate  => $rundeck::ssl_certificate,
      destkeypass  => $rundeck::key_password,
      trustcacerts => true,
      ;
    "${rundeck::config::properties_dir}/ssl/keystore":
      password => $rundeck::keystore_password,
      ;
    "${rundeck::config::properties_dir}/ssl/truststore":
      password => $rundeck::truststore_password,
      ;
  }
}
