# @summary Installs promtail
#
# Installs promtail
#
# @api private
class promtail::install {
  include archive

  case $facts['kernel'] {
    'Linux': {
      $data_dir = '/usr/local/promtail_data'
      $release_file_name = 'promtail_linux_amd64'
    }
    default: { fail("${facts['kernel']} is not yet supported") }
  }

  $version_dir = "${data_dir}/promtail-${promtail::version}"
  $binary_path = "${version_dir}/${release_file_name}"

  file { [$data_dir, $version_dir]:
    ensure => directory,
  }

  archive { "${binary_path}.gz":
    ensure        => present,
    source        => "https://github.com/grafana/loki/releases/download/v0.3.0/${release_file_name}.gz",
    extract       => true,
    extract_path  => $version_dir,
    creates       => $binary_path,
    checksum      => $promtail::checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

  file {
    $binary_path:
      ensure  => file,
      mode    => '0755',
      require => Archive["${binary_path}.gz"],
    ;
    "${promtail::bin_dir}/promtail":
      ensure  => link,
      target  => $binary_path,
      require => File[$binary_path],
      notify  => Service['promtail'],
    ;
  }
}
