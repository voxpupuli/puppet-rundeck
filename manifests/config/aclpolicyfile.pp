# @summary This define will create a custom acl policy file.
#
# @example Admin access.
#   rundeck::config::aclpolicyfile { 'myPolicyFile':
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
# @param owner
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param properties_dir
#   The rundeck configuration directory.
#
define rundeck::config::aclpolicyfile (
  Array[Hash]          $acl_policies,
  String               $group          = 'rundeck',
  String               $owner          = 'rundeck',
  Stdlib::Absolutepath $properties_dir = '/etc/rundeck',
) {
  ensure_resource('file', $properties_dir, { 'ensure' => 'directory', 'mode' => '0755' })

  file { "${properties_dir}/${name}.aclpolicy":
    owner   => $owner,
    group   => $group,
    mode    => '0640',
    content => epp('rundeck/aclpolicy.epp'),
  }
}
