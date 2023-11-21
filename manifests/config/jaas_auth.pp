# @api private
#
# @summary This private class is called from rundeck::config used to manage jaas authentication for rundeck.
#
class rundeck::config::jaas_auth {
  assert_private()

  $_auth_config = $rundeck::auth_config
  $_auth_types  = $_auth_config.keys

  if 'file' in $_auth_types {
    file { "${rundeck::config::properties_dir}/realm.properties":
      content => Sensitive(epp($rundeck::realm_template, { _auth_config => $_auth_config })),
      mode    => '0600',
    }
  } else {
    file { "${rundeck::config::properties_dir}/realm.properties":
      ensure => absent,
    }
  }

  if 'file' in $_auth_types and 'ldap' in $_auth_types {
    $_ldap_login_module = 'JettyCombinedLdapLoginModule'
  } else {
    $_ldap_login_module = 'JettyCachingLdapLoginModule'
  }

  file { "${rundeck::config::properties_dir}/jaas-loginmodule.conf":
    content => Sensitive(epp('rundeck/jaas-auth.conf.epp', { _auth_config => $_auth_config, _ldap_login_module => $_ldap_login_module })),
    mode    => '0600',
  }
}
