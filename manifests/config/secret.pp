# @summary This define will manage secrets in key storage.
#
# @example Basic usage.
#   rundeck::config::secret { 'keys/mysecret':
#     content => 'very_secure_password',
#   }
#
# @param content
#   The secret content.
# @param ensure
#   Whether or not the secret should be present.
# @param type
#   The type of the secret.
# @param keystorage_path
#   The path in rundeck key storage.
# @param owner
#   The user that rundeck is installed as.
# @param group
#   The group permission that rundeck is installed as.
# @param keystorage_dir
#   The directory on filesystem where the secret files are stored.
#
define rundeck::config::secret (
  Variant[String, Sensitive[String]] $content,
  Enum['absent', 'present'] $ensure = 'present',
  Enum['password', 'privateKey', 'publicKey'] $type = 'password',
  String[1] $keystorage_path = $name,
  String[1] $owner = 'rundeck',
  String[1] $group = 'rundeck',
  Stdlib::Absolutepath $keystorage_dir = '/var/lib/rundeck/keystorage',
) {
  require rundeck::cli

  ensure_resource('file', $keystorage_dir, { 'ensure' => 'directory', 'owner' => $owner, 'group' => $group, 'mode' => '0755' })

  $_filename = join([basename($keystorage_path), $type], '.')

  file { "${keystorage_dir}/${_filename}":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0400',
    content => $content,
  }

  if $ensure == 'absent' {
    exec { "Remove rundeck ${type}: ${keystorage_path}":
      command     => "rd keys delete -p '${keystorage_path}'",
      path        => ['/bin', '/usr/bin', '/usr/local/bin'],
      environment => $rundeck::cli::environment,
      onlyif      => "rd keys info -p '${keystorage_path}'",
    }
  } else {
    exec {
      "Create rundeck ${type}: ${keystorage_path}":
        command     => "rd keys create -t ${type} -p '${keystorage_path}' -f '${keystorage_dir}/${_filename}'",
        path        => ['/bin', '/usr/bin', '/usr/local/bin'],
        environment => $rundeck::cli::environment,
        unless      => "rd keys info -p '${keystorage_path}'",
        require     => File["${keystorage_dir}/${_filename}"],
      ;
      "Update rundeck ${type}: ${keystorage_path}":
        command     => "rd keys update -t ${type} -p '${keystorage_path}' -f '${keystorage_dir}/${_filename}'",
        onlyif      => "rd keys info -p '${keystorage_path}'",
        refreshonly => true,
        path        => ['/bin', '/usr/bin', '/usr/local/bin'],
        environment => $rundeck::cli::environment,
        subscribe   => File["${keystorage_dir}/${_filename}"],
        require     => Exec["Create rundeck ${type}: ${keystorage_path}"],
      ;
    }
  }
}
