#
# Author: Zoltan Lanyi <zoltan.lanyi@gmail.com>
# Date  : 03.06.2016
# 
define rundeck::config::resource::securityroles (
  Stdlib::Absolutepath $web_xml = "${rundeck::home_dir}/exp/webapp/WEB-INF/web.xml"
) {
  augeas { "rundeck/web.xml/security-role/role-name/${name}":
    lens    => 'Xml.lns',
    incl    => $web_xml,
    onlyif  => "match web-app/security-role/role-name[#text = '${name}'] size == 0",
    changes => ["set web-app/security-role/#text[last()] '\t\t'", "set web-app/security-role/role-name[last()+1]/#text '${name}'", "set web-app/security-role/#text[last()+1] '\t'"],
  }
}
