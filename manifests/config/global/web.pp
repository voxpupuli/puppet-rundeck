# Author::    Wil Cooley <wcooley(at)nakedape.cc>
# License::   MIT
#
# == Class: rundeck::config::global::web
#
# Manage the application's +web.xml+.
#
# Currently only manages the +<security-role>+ required for any user to login:
# http://rundeck.org/docs/administration/authenticating-users.html#security-role
#
# === Parameters
#
# [*security_role*]
#   Name of role that is required for all users to be allowed access.
#
class rundeck::config::global::web (
  $security_role = $rundeck::params::security_role,
) inherits rundeck::params {

  augeas { 'rundeck/web.xml/security-role/role-name':
    lens    => 'Xml.lns',
    incl    => $rundeck::params::web_xml,
    changes => [ "set web-app/security-role/role-name/#text '${security_role}'" ],
  }
}
