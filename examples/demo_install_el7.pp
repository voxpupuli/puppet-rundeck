# Simple demo-install of rundeck on EL7 (CentOS, RHEL)
#
# Pre-requisites:
# - Installed modules
# puppet module install puppetlabs-java
# puppet module install puppet-rundeck
# puppet module install crayfishx-firewalld
# - $::fqdn fact needs to be working
#
# After installation:
# - Webinterface on http://${::fqdn}:4440
# - Login with admin/admin
#

include ::java
include ::rundeck
include ::firewalld

firewalld_port { 'Rundeck HTTP port':
  ensure   => present,
  zone     => 'public',
  port     => 4440,
  protocol => 'tcp',
}

Class['java'] -> Class['rundeck']

