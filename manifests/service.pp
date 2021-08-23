# @summary Creates a service defintion for promtail
#
# Creates a service defintion for promtail
#
# @api private
class promtail::service {
  case $facts['kernel'] {
    'Linux': {
      include systemd::systemctl::daemon_reload
      systemd::unit_file { 'promtail.service':
        ensure => present,
        source => 'puppet:///modules/promtail/promtail.service',
        enable => $promtail::service_enable,
        active => $promtail::service_ensure == 'running'
      }
    }
    default: { fail("${facts['kernel']} is not supported") }
  }
}
