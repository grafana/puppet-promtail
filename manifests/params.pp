# @summary Default promtail variables
#
# Sets default variables per OS
#
# @api private
class promtail::params {
  case $facts['kernel'] {
    'Linux': {
      $bin_dir = '/usr/local/bin'
      $data_dir = '/usr/local/promtail_data'
      $config_dir = '/etc/promtail'
    }
    'windows': {
      $bin_dir = 'C:\\Program Files\\promtail'
      $data_dir = "${bin_dir}\\versions"
      $config_dir = "${bin_dir}\\config"
    }
    default: { fail("${facts['kernel']} is not yet supported") }
  }
}
