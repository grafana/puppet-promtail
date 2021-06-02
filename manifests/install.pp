# @summary Installs promtail
#
# Installs promtail
#
# @api private
class promtail::install {
  include archive

  case $facts['os']['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'aarch64':         { $arch = 'arm64' }
    'armv7l':          { $arch = 'arm' }
    default:           { fail("Unsupported kernel architecture: ${facts['os']['architecture']}") }
  }

  case $facts['kernel'] {
    'Linux': {
      $data_dir = '/usr/local/promtail_data'
      if versioncmp($promtail::version, 'v0.3.0') > 0 {
        $release_file_name = "promtail-linux-${arch}"
      } else {
        $release_file_name = "promtail_linux_${arch}"
      }
    }
    default: { fail("${facts['kernel']} is not yet supported") }
  }

  if versioncmp($promtail::version, 'v1.0.0') > 0 {
    $archive_type = 'zip'
  } else {
    $archive_type = 'gz'
  }

  $version_dir = "${data_dir}/promtail-${promtail::version}"
  $binary_path = "${version_dir}/${release_file_name}"

  file { [$data_dir, $version_dir]:
    ensure => directory,
  }

  archive { "${binary_path}.gz":
    ensure        => present,
    source        => "${promtail::source_url}/${promtail::version}/${release_file_name}.${archive_type}",
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
