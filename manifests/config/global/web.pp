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
  $security_role   = $rundeck::params::security_role,
  $session_timeout = $rundeck::params::session_timeout,
) inherits rundeck::params {

  augeas { 'rundeck/web.xml/security-role/role-name':
    lens    => 'Xml.lns',
    incl    => $rundeck::params::web_xml,
    changes => [ "set web-app/security-role/role-name/#text '${security_role}'" ],
  }

  augeas { 'rundeck/web.xml/session-config/session-timeout':
    lens    => 'Xml.lns',
    incl    => $rundeck::params::web_xml,
    changes => [ "set web-app/session-config/session-timeout/#text '${session_timeout}'" ],
  }
}
