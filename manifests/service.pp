# @summary Creates a service defintion for promtail
#
# Creates a service defintion for promtail
#
# @api private
class promtail::service {
  case $facts['kernel'] {
    'Linux': {
      systemd::unit_file { 'promtail.service':
        source => 'puppet:///modules/promtail/promtail.service',
        notify => Service['promtail'],
      }

      service { 'promtail':
        ensure  => $promtail::service_ensure,
        require => Systemd::Unit_file['promtail.service'],
      }
    }
    default: { fail("${facts['kernel']} is not supported")}
  }
}
