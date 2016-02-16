# == Define rundeck::config::file_keystore
#
# This type will create the 'content' and 'meta' components for the key to
# be stored, and currently supports password-based public keys.  Private
# keys are also supported, but not recommended to be privisioned via this mechanism
# without the proper security policies for the private key data in place
#
# === Parameters
#
# [*value*]
#   The actual value (password) of the named key
#
# [*path*]
#   The actual value (password) of the named key
#
# [*data_type*]
#   Date type (password, public-key or private-key)
#
# [*content_type*]
#   MIME type of the content
#
# [*user*]
#   default system user for the Rundeck framework
#
# [*group*]
#   default system group for the Rundeck framework
#
# [*content_size*]
#   Size of the content string in bytes
#
# [*content_mask*]
#   Content mask (default is 'content')
#
# [*content_creation_time*]
#   When the key was first created
#
# [*auth_created_username*]
#   User who created the key
#
# [*auth_modified_username*]
#   User who last modified the key
#
# [*file_keystorage_dir*]
#   Base directory for file-based key storage (defaulted to /var/lib/rundeck/var/storage)
#

define rundeck::config::file_keystore (
  $value,
  $path,
  $data_type,
  $content_type,
  $user = $::rundeck::config::user,
  $group = $::rundeck::config::group,
  $content_creation_time = chomp(generate('/bin/date', '+%Y-%m-%dT%H:%M:%SZ')),
  $content_modify_time = chomp(generate('/bin/date', '+%Y-%m-%dT%H:%M:%SZ')),
  $content_size = size($value),
  $content_mask = 'content',
  $auth_created_username = $::rundeck::framework_config['framework.ssh.user'],
  $auth_modified_username = $::rundeck::framework_config['framework.ssh.user'],
  $file_keystorage_dir = $::rundeck::file_keystorage_dir,
) {

  validate_re($data_type, [ 'password', 'public', 'private' ])
  validate_re($content_type, [ 'application/x-rundeck-data-password', 'application/pgp-keys', 'application/octet-stream' ])

  $key_fqpath = "${file_keystorage_dir}/content/keys/${path}"
  $meta_fqpath = "${file_keystorage_dir}/meta/keys/${path}"

  exec { "create ${path}_${name} key path":
    command => "mkdir -m 775 -p ${key_fqpath}; chown -R ${user}:${group} ${key_fqpath}",
    creates => $key_fqpath,
  }

  exec { "create ${path}_${name} meta path":
    command => "mkdir -m 775 -p ${meta_fqpath}; chown -R ${user}:${group} ${meta_fqpath}",
    creates => $meta_fqpath,
  }

  File {
    ensure => present,
    mode   => '0664',
    owner  => $user,
    group  => $group,
  }

  file { "${key_fqpath}/${name}.${data_type}":
    content => $value,
    require => Exec["create ${path}_${name} key path"],
    replace => false,
  }

  file { "${meta_fqpath}/${name}.${data_type}":
    content => template('rundeck/file_keystorage_meta.erb'),
    require => Exec["create ${path}_${name} meta path"],
    replace => false,
  }

}
