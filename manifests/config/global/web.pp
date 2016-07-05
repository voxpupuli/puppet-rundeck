# Author::    Wil Cooley <wcooley(at)nakedape.cc>
# License::   MIT
#
# == Class: rundeck::config::global::web
#
# Manage the application's +web.xml+.
#
# Currently only manages the +<security-role>+ required for any user to login and session timout:
# http://rundeck.org/docs/administration/authenticating-users.html#security-role
# http://rundeck.org/docs/administration/configuration-file-reference.html#session-timeout
#
# === Parameters
#
# [*security_role*]
#   Name of role that is required for all users to be allowed access.
#
# [*session_timeout*]
#   Session timeout is an expired time limit for a logged in Rundeck GUI user which as been inactive for a period of time.
#
# [*security_roles_array_enabled*]
# Boolen value if you want to have more roles in web.xml
#
# [*security_roles_array*]
# Array value if you set the value 'security_roles_array_enabled' to true.
#
class rundeck::config::global::web (
  $security_role                            = $rundeck::params::security_role,
  $session_timeout                          = $rundeck::params::session_timeout,
  $security_roles_array_enabled             = $rundeck::params::security_roles_array_enabled,
  $security_roles_array                     = $rundeck::params::security_roles_array,
) inherits rundeck::params {

  if $security_roles_array_enabled {
    rundeck::config::securityroles { $security_roles_array: }
  }
  else {
    augeas { 'rundeck/web.xml/security-role/role-name':
      lens    => 'Xml.lns',
      incl    => $rundeck::params::web_xml,
      changes => [ "set web-app/security-role/role-name/#text '${security_role}'" ],
    }
  }

  augeas { 'rundeck/web.xml/session-config/session-timeout':
    lens    => 'Xml.lns',
    incl    => $rundeck::params::web_xml,
    changes => [ "set web-app/session-config/session-timeout/#text '${session_timeout}'" ],
  }

  if $rundeck::preauthenticated_config['enabled'] {
    augeas { 'rundeck/web.xml/security-constraint/auth-constraint':
      lens    => 'Xml.lns',
      incl    => $rundeck::params::web_xml,
      changes => [ 'rm web-app/security-constraint/auth-constraint' ],
    }
  }
  else {
    augeas { 'rundeck/web.xml/security-constraint/auth-constraint/role-name':
      lens    => 'Xml.lns',
      incl    => $rundeck::params::web_xml,
      changes => [ "set web-app/security-constraint[last()+1]/auth-constraint/role-name/#text '*'" ],
      onlyif  => 'match web-app/security-constraint/auth-constraint/role-name size == 0',
    }
  }
}
