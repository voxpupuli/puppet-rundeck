# @api private
#
# @summary This private class is used to manage the keys of the Rundeck key storage facility if a file-based backend is used.
#
class rundeck::config::global::file_keystore {
  assert_private()

  $file_keystorage_dir = $rundeck::file_keystorage_dir
  $group               = $rundeck::config::group
  $keys                = $rundeck::config::file_keystorage_keys
  $user                = $rundeck::config::user

  create_resources(rundeck::config::file_keystore, $keys, { 'user' => $user, 'group' => $group })
}
