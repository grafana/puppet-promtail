# @summary Creates files and folders associated with promtail's config
#
# Creates files and folders associated with promtail's config
#
# @api private
class promtail::config {
  case $facts['kernel'] {
    'Linux': {
      $config_dir = '/etc/promtail'
    }
    default: { fail("${facts['kernel']} is not supported")}
  }

  file {
    $config_dir:
      ensure => directory,
    ;
    "${config_dir}/config.yaml":
      ensure  => file,
      content => promtail::to_yaml($promtail::config_hash),
      notify  => Service['promtail'],
    ;
  }

  if $promtail::password_file_path and $promtail::password_file_content {
    file { $promtail::password_file_path:
      ensure    => file,
      mode      => '0600',
      content   => unwrap($promtail::password_file_content),
      show_diff => false,
    }
  }
}
