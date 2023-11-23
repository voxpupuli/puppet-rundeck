# @summary This define will create a custom acl policy file.
#
# @example Admin access.
#   rundeck::config::aclpolicyfile { 'myPolicyFile':
#     acl_policies => [
#       {
#         'description' => 'Admin, all access',
#         'context'     => { 'project' => '.*' },
#         'for'         => {
#           'resource' => [{ 'allow' => '*' }],
#           'adhoc'    => [{ 'allow' => '*' }],
#           'job'      => [{ 'allow' => '*' }],
#           'node'     => [{ 'allow' => '*' }],
#         },
#         'by'          => [{ 'group' => ['admin'] }],
#       },
#       {
#         'description' => 'Admin, all access',
#         'context'     => { 'application' => 'rundeck' },
#         'for'         => {
#           'project'     => [{ 'allow' => '*' }],
#           'resource'    => [{ 'allow' => '*' }],
#           'storage'     => [{ 'allow' => '*' }],
#         },
#         'by'          => [{ 'group' => ['admin'] }],
#       },
#     ],
#   }
#
# @param acl_policies
#   An array of hashes containing acl policies. See example.
# @param ensure
#   Set present or absent to add or remove the acl policy file.
# @param owner
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param properties_dir
#   The rundeck configuration directory.
#
define rundeck::config::aclpolicyfile (
  Array[Hash]               $acl_policies,
  Enum['present', 'absent'] $ensure         = 'present',
  String                    $owner          = 'rundeck',
  String                    $group          = 'rundeck',
  Stdlib::Absolutepath      $properties_dir = '/etc/rundeck',
) {
  validate_rd_policy($acl_policies)

  ensure_resource('file', $properties_dir, { 'ensure' => 'directory', 'owner' => $owner, 'group' => $group, 'mode' => '0755' })

  file { "${properties_dir}/${name}.aclpolicy":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => epp('rundeck/aclpolicy.epp', { _acl_policies => $acl_policies }),
  }
}
