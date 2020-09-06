#
# Configuring shared authentication credentials
# Performs LDAP authentication and file authorization
#
class { 'rundeck':
  auth_types  => ['ldap_shared'],
  auth_config => {
    'file' => {
      'auth_users' => [
        {
          'username' => 'rooty',
          'roles'    => ['admin'],
        },
        {
          'username' => 'stan',
          'roles'    => ['sre'],
        }
      ],
    },
    'ldap' => {
      'url'                            => 'ldap://ldap:389',
      'force_binding'                  => true,
      'bind_dn'                        => 'cn=ProxyUser,dc=example,dc=com',
      'bind_password'                  => 'secret',
      'user_base_dn'                   => 'ou=Users,dc=example,dc=com',
      'user_rdn_attribute'             => 'uid',
      'user_id_attribute'              => 'uid',
      'user_object_class'              => 'inetOrgPerson',
      'role_base_dn'                   => 'ou=Groups,dc=example,dc=com',
      'role_name_attribute'            => 'cn',
      'role_member_attribute'          => 'memberUid',
      'role_username_member_attribute' => 'memberUid',
      'role_object_class'              => 'posixGroup',
      'supplemental_roles'             => 'user',
      'nested_groups'                  => false,
    },
  },
}
