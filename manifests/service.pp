# @summary Creates a service defintion for promtail
#
# Creates a service defintion for promtail
#
# @api private
class promtail::service {
  $service_to_notify = $facts['kernel'] ? {
    'Linux'   => Systemd::Unit_file['promtail.service'],
    'windows' => Service['promtail'],
    default   => undef
  }

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
      if $promtail::service_enable {
        $running_mode = 'auto'
      } else {
        $running_mode = 'disabled'
      }

      if $promtail::service_ensure == 'present' {
        exec { 'install_service':
          command  => "sc.exe create promtail binPath=\"${promtail::install::binary_link_path} --config.file ${promtail::config::config_file}\" displayname=\"Grafana Promtail\" start= ${running_mode}",
          provider => powershell,
          unless   => 'sc.exe query promtail',
        }
      } elsif {
        exec { 'install_service':
          command  => 'sc.exe delete promtail',
          provider => powershell,
          onlyif   => 'sc.exe query promtail',
        }
      }
    }
    default: { fail("${facts['kernel']} is not supported") }
  }
}
