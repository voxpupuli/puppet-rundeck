# Author::    Johannes Graf (mailto:graf@synyx.de)
# Copyright:: Copyright (c) 2015 synyx GmbH & Co. KG
# License::   MIT

# == Define rundeck::config::aclpolicyfile
#
# Use this define to create a custom acl policy file
#
# === Parameters
#
# [*acl_policies*]
#  An array containing acl policies. See rundeck::params::acl_policies / rundeck::params::api_policies as an example.
#
# [*group*]
#  The group permission that rundeck is installed as.
#
# [*owner*]
#  The user that rundeck is installed as.
#
# [*properties_dir*]
#  The rundeck configuration directory.
#
# === Examples
#
# Create the admin.aclpolicy file:
#
# rundeck::config::aclpolicyfile { 'myPolicyFile':
#   acl_policies => [
#     {
#       'description' => 'Admin, all access',
#       'context' => {
#         'type' => 'project',
#         'rule' => '.*'
#       },
#       'resource_types' => [
#         { 'type'  => 'resource', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         { 'type'  => 'adhoc', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         { 'type'  => 'job', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         { 'type'  => 'node', 'rules' => [{ 'name' => 'allow','rule' => '*' }] }
#       ],
#       'by' => {
#         'groups'    => ['admin'],
#         'usernames' => undef
#       }
#     },
#     {
#       'description' => 'Admin, all access',
#       'context' => {
#         'type' => 'application',
#         'rule' => 'rundeck'
#       },
#       'resource_types' => [
#         { 'type'  => 'resource', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         { 'type'  => 'project', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         { 'type'  => 'storage', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#       ],
#       'by' => {
#         'groups'    => ['admin'],
#         'usernames' => undef
#       }
#     }
#   ],
# }
#
define rundeck::config::aclpolicyfile (
  Array $acl_policies,
  String $group                        = 'rundeck',
  String $owner                        = 'rundeck',
  Stdlib::Absolutepath $properties_dir = '/etc/rundeck',
  String $template_file                = "${module_name}/aclpolicy.erb",
) {
  file { "${properties_dir}/${name}.aclpolicy":
    owner   => $owner,
    group   => $group,
    mode    => '0640',
    content => template($template_file),
  }
}
