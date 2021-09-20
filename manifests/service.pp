# @summary Creates a service defintion for promtail
#
# Creates a service defintion for promtail
#
# @api private
class promtail::service {
  $service_to_notify = Service['promtail']

  case $facts['kernel'] {
    'Linux': {
      systemd::unit_file { 'promtail.service':
        source => 'puppet:///modules/promtail/promtail.service',
        notify => Service['promtail'],
      }

      service { 'promtail':
        ensure  => $promtail::service_ensure,
        enable  => $promtail::service_enable,
        require => Systemd::Unit_file['promtail.service'],
      }
    }
    'windows': {
      nssm::service { 'promtail':
        ensure         => $promtail::service_ensure,
        command        => $promtail::install::binary_link_path,
        app_parameters => "--config.file='${promtail::config::config_file}'",
        log_file_path  => $promtail::log_file_path
      }

      service { 'promtail':
        ensure  => $promtail::service_ensure,
        enable  => $promtail::service_enable,
        require => Nssm::Service['promtail'],
      }
    }
    default: { fail("${facts['kernel']} is not supported") }
  }
}
