# @summary Installs promtail
#
# Installs promtail
#
# @api private
class promtail::install {
  include archive

  case $facts['os']['architecture'] {
    'x86_64', 'amd64', 'x64': { $arch = 'amd64' }
    'aarch64':                { $arch = 'arm64' }
    'armv7l':                 { $arch = 'arm' }
    default:                  { fail("Unsupported kernel architecture: ${facts['os']['architecture']}") }
  }

  case $facts['kernel'] {
    'Linux': {
      if versioncmp($promtail::version, 'v0.3.0') > 0 {
        $release_file_name = "promtail-linux-${arch}"
      } else {
        $release_file_name = "promtail_linux_${arch}"
      }
    }
    'windows': {
      if versioncmp($promtail::version, 'v0.3.0') > 0 {
        $release_file_name = "promtail-windows-${arch}.exe"
      } else {
        $release_file_name = "promtail_windows_${arch}.exe"
      }
    }
    default: { fail("${facts['kernel']} is not yet supported") }
  }

  if versioncmp($promtail::version, 'v1.0.0') > 0 {
    $archive_type = 'zip'
  } else {
    $archive_type = 'gz'
  }

  $version_dir = $facts['kernel'] ? {
    'windows' => "${promtail::data_dir}\\${promtail::version}",
    default => "${promtail::data_dir}/promtail-${promtail::version}"
  }
  $binary_path = $facts['kernel'] ? {
    'windows' => "${version_dir}\\${release_file_name}",
    default => "${version_dir}/${release_file_name}"
  }

  file { [$promtail::bin_dir, $promtail::data_dir, $version_dir]:
    ensure => directory,
  }

  archive { "${binary_path}.${archive_type}":
    ensure        => present,
    source        => "${promtail::source_url}/${promtail::version}/${release_file_name}.${archive_type}",
    extract       => true,
    extract_path  => $version_dir,
    creates       => $binary_path,
    checksum      => $promtail::checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

  $binary_link_path = $facts['kernel'] ? {
    'windows' => "${promtail::bin_dir}\\promtail.exe",
    default => "${promtail::bin_dir}/promtail"
  }
  file {
    $binary_path:
      ensure  => file,
      mode    => '0755',
      require => Archive["${binary_path}.${archive_type}"],
      ;
    $binary_link_path:
      ensure  => link,
      target  => $binary_path,
      require => File[$binary_path],
      notify  => $promtail::service::service_to_notify
      ;
  }
}
