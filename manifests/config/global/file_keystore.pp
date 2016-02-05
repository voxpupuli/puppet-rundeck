# == Class rundeck::config::global::file_keystore
#
# This private class is called from rundeck::config used to manage the keys of
# the Rundeck key storage facility, if a file-based backend is used
#
class rundeck::config::global::file_keystore(
  $user = $rundeck::config::user,
  $group = $rundeck::config::group,
  $keys = $::rundeck::config::file_keystorage_keys,
  $file_keystorage_dir = $::rundeck::file_keystorage_dir,
) {

  File {
    ensure => directory,
    mode   => '0775',
    owner  => $user,
    group  => $group,
  }

  file { 'key storage base dir':
    path => $file_keystorage_dir,
  } ->

  file { 'content base':
    path => "${file_keystorage_dir}/content",
  } ->

  file { 'meta base':
    path => "${file_keystorage_dir}/meta",
  } ->

  file { 'content keys':
    path => "${file_keystorage_dir}/content/keys",
  } ->

  file { 'meta keys':
    path => "${file_keystorage_dir}/meta/keys",
  }

  create_resources(rundeck::config::file_keystore, $keys)

}
