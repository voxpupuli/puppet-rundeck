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
class rundeck::config::global::web (
  $preauthenticated_config = $rundeck::preauthenticated_config,
  $security_role           = $rundeck::security_role,
  $session_timeout         = $rundeck::session_timeout,
  $web_xml                 = $rundeck::web_xml,
) {

  assert_private()

  Augeas {
    lens => 'Xml.lns',
    incl => $web_xml,
  }

  augeas { 'rundeck/web.xml/security-role/role-name':
    changes => [ "set web-app/security-role/role-name/#text '${security_role}'" ],
  }

  augeas { 'rundeck/web.xml/session-config/session-timeout':
    changes => [ "set web-app/session-config/session-timeout/#text '${session_timeout}'" ],
  }

  if $preauthenticated_config['enabled'] {
    augeas { 'rundeck/web.xml/security-constraint/auth-constraint':
      changes => [ 'rm web-app/security-constraint/auth-constraint' ],
    }
  }
  else {
    augeas { 'rundeck/web.xml/security-constraint/auth-constraint/role-name':
      changes => [ "set web-app/security-constraint[last()+1]/auth-constraint/role-name/#text '*'" ],
      onlyif  => 'match web-app/security-constraint/auth-constraint/role-name size == 0',
    }
  }
}
