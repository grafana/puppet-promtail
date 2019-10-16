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

  file { $config_dir:
    ensure => directory,
  }

  $config_file = "${config_dir}/config.yaml"

  concat { $config_file:
    ensure => present,
    notify => Service['promtail'],
  }

  concat::fragment { 'config_header':
    target  => $config_file,
    content => "---\n",
    order   => '01',
  }

  # Configures the server for Promtail.
  # [server: <server_config>]
  if $promtail::server_config_hash {
    concat::fragment { 'server_config_hash':
      target  => $config_file,
      content => $promtail::server_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '10',
    }
  }

  # Describes how Promtail connects to multiple instances
  # of Loki, sending logs to each.
  # clients:
  #   - [<client_config>]
  concat::fragment { 'clients_config_hash':
    target  => $config_file,
    content => $promtail::clients_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
    order   => '20',
  }

  # Describes how to save read file offsets to disk
  # [positions: <position_config>]
  concat::fragment { 'positions_config_hash':
    target  => $config_file,
    content => $promtail::positions_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
    order   => '30',
  }

  # scrape_configs:
  #   - [<scrape_config>]
  concat::fragment { 'scrape_configs_hash':
    target  => $config_file,
    content => $promtail::scrape_configs_hash.promtail::to_yaml.promtail::strip_yaml_header,
    order   => '40',
  }

  # Configures how tailed targets will be watched.
  # [target_config: <target_config>]
  if $promtail::target_config_hash {
    concat::fragment { 'target_config_hash':
      target  => $config_file,
      content => $promtail::target_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
      order   => '50',
    }
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
