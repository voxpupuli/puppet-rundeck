# @api private
#
# @summary This private class is called from rundeck::config used to manage jaas authentication for rundeck.
#
class rundeck::config::jaas_auth {
  $auth_types = $rundeck::auth_config.keys

  if 'file' in $auth_types {
    file { "${rundeck::config::properties_dir}/realm.properties":
      content => Sensitive(epp($rundeck::realm_template)),
      mode    => '0600',
      require => File[$rundeck::config::properties_dir],
    }
  } else {
    file { "${rundeck::config::properties_dir}/realm.properties":
      ensure => absent,
    }
  }

  if 'file' in $auth_types and 'ldap' in $auth_types {
    $ldap_login_module = 'JettyCombinedLdapLoginModule'
  } else {
    $ldap_login_module = 'JettyCachingLdapLoginModule'
  }

  file { "${rundeck::config::properties_dir}/jaas-auth.conf":
    content => Sensitive(epp($rundeck::auth_template)),
    mode    => '0600',
    require => File[$rundeck::config::properties_dir],
  }
}
