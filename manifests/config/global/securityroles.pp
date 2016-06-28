#
# Author: Zoltan Lanyi <zoltan.lanyi@gmail.com>
# Date  : 03.06.2016
# 

define rundeck::config::global::securityroles ($security_role = $title) {
  augeas { "rundeck/web.xml/security-role/role-name/${security_role}":
    lens    => 'Xml.lns',
    incl    => $rundeck::params::web_xml,
    onlyif  => "match web-app/security-role/role-name[#text = '${security_role}'] size == 0",
    changes => ["set web-app/security-role/#text[last()] '\t\t'", "set web-app/security-role/role-name[last()+1]/#text '${security_role}'", "set web-app/security-role/#text[last()+1] '\t'"]
  }
}
