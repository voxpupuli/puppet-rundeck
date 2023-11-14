# @summary This class is called from rundeck to manage service.
#
class rundeck::service {
  assert_private()

  if $rundeck::service_config {
    file { '/etc/init/rundeckd.conf':
      ensure  => file,
      mode    => '0644',
      content => template($rundeck::service_config),
    }
  }

  if $rundeck::service_script {
    file { '/etc/init.d/rundeckd':
      ensure  => file,
      mode    => '0755',
      content => template($rundeck::service_script),
    }
  }

  service { $rundeck::service_name:
    ensure     => $rundeck::service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
