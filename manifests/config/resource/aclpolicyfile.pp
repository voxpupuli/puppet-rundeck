# @summary This define will create a custom acl policy file.
#
# @example Admin access.
#   rundeck::config::resource::aclpolicyfile { 'myPolicyFile':
#     acl_policies => [
#       {
#         'description'    => 'Admin, all access',
#         'context'        => {
#           'type' => 'project',
#           'rule' => '.*',
#         },
#         'resource_types' => [
#           { 'type'  => 'resource', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#           { 'type'  => 'adhoc', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#           { 'type'  => 'job', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#           { 'type'  => 'node', 'rules' => [{ 'name' => 'allow','rule' => '*' }] }
#         ],
#         'by'             => {
#           'group'    => ['admin'],
#           'username' => undef,
#         }
#       },
#       {
#         'description'    => 'Admin, all access',
#         'context'        => {
#           'type' => 'application',
#           'rule' => 'rundeck',
#         },
#         'resource_types' => [
#           { 'type'  => 'resource', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#           { 'type'  => 'project', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#           { 'type'  => 'storage', 'rules' => [{ 'name' => 'allow','rule' => '*' }] },
#         ],
#         'by'             => {
#           'group'    => ['admin'],
#           'username' => undef,
#         }
#       }
#     ],
#   }
#
# @param acl_policies
#   An array of hashes containing acl policies. See example.
# @param group
#   The group permission that rundeck is installed as.
# @param owner
#   The user that rundeck is installed as.
# @param properties_dir
#   The rundeck configuration directory.
# @param template_file
#   The template used for acl policy. Default is rundeck/aclpolicy.erb
#
define rundeck::config::resource::aclpolicyfile (
  Array[Hash]          $acl_policies,
  String               $group          = 'rundeck',
  String               $owner          = 'rundeck',
  Stdlib::Absolutepath $properties_dir = '/etc/rundeck',
  String               $template_file  = "${module_name}/aclpolicy.erb",
) {
  file { "${properties_dir}/${name}.aclpolicy":
    owner   => $owner,
    group   => $group,
    mode    => '0640',
    content => template($template_file),
  }
}
