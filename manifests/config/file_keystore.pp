# == Define rundeck::config::file_keystore
#
# This type will create the 'content' and 'meta' components for the key to
# be stored, and currently supports password-based public keys.  Private
# keys are also supported, but not recommended to be privisioned via this mechanism
# without the proper security policies for the private key data in place
#
# === Parameters
#
# [*auth_created_username*]
#   User who created the key
#
# [*auth_modified_username*]
#   User who last modified the key
#
# [*content_creation_time*]
#   When the key was first created
#
# [*content_mask*]
#   Content mask (default is 'content')
#
# [*content_size*]
#   Size of the content string in bytes
#
# [*content_type*]
#   MIME type of the content
#
# [*data_type*]
#   Date type (password, public-key or private-key)
#
# [*file_keystorage_dir*]
#   Base directory for file-based key storage (defaulted to /var/lib/rundeck/var/storage)
#
# [*group*]
#   default system group for the Rundeck framework
#
# [*path*]
#   The actual value (password) of the named key
#
# [*user*]
#   default system user for the Rundeck framework
#
# [*value*]
#   The actual value (password) of the named key
#
define rundeck::config::file_keystore (
  Enum['application/x-rundeck-data-password', 'application/pgp-keys', 'application/octet-stream'] $content_type,
  Enum['password', 'public', 'private'] $data_type,
  String $path,
  String $value,
  String $auth_created_username             = $rundeck::framework_config['framework.ssh.user'],
  String $auth_modified_username            = $rundeck::framework_config['framework.ssh.user'],
  String $content_creation_time             = chomp(generate('/bin/date', '+%Y-%m-%dT%H:%M:%SZ')),
  String $content_mask                      = 'content',
  String $content_modify_time               = chomp(generate('/bin/date', '+%Y-%m-%dT%H:%M:%SZ')),
  Optional[Integer] $content_size           = undef,
  Stdlib::Absolutepath $file_keystorage_dir = $rundeck::file_keystorage_dir,
  String $group                             = $rundeck::config::group,
  String $user                              = $rundeck::config::user,
) {
  ensure_resource('file', [$file_keystorage_dir], { 'ensure' => 'directory' })

  if !$content_size {
    $content_size_value = size($value)
  } else {
    $content_size_value = $content_size
  }

  $key_fqpath = "${file_keystorage_dir}/content/keys/${path}"
  $key_dirtree = dirtree($key_fqpath, $file_keystorage_dir)
  $meta_fqpath = "${file_keystorage_dir}/meta/keys/${path}"
  $meta_dirtree = dirtree($meta_fqpath, $file_keystorage_dir)

  File {
    ensure => present,
    mode   => '0664',
    owner  => $user,
    group  => $group,
  }

  ensure_resource('file', [$meta_dirtree, $key_dirtree], { 'ensure' => 'directory' })

  file { "${key_fqpath}/${name}.${data_type}":
    content => $value,
    replace => false,
    require => File[$key_fqpath],
  }

  file { "${meta_fqpath}/${name}.${data_type}":
    content => template('rundeck/file_keystorage_meta.erb'),
    replace => false,
    require => File[$meta_fqpath],
  }
}
