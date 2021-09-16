# @summary promtail's main interface. All interactions should be with this class.
#
# promtail's main interface. All interactions should be with this class. The promtail
# module is intended to install and configure Grafana's promtail tool for shipping
# logs to Loki.
#
# @param [Boolean] service_enable
#   The value passed to the service resource's enable parameter for promtail's service
#
# @param [Enum['running', 'stopped']] service_ensure
#   The value passed to the service resource's ensure parameter for promtail's service
#
# @param [Hash] clients_config_hash
#   Describes how Promtail connects to multiple instances of Loki, sending logs to each.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md
#   for all parameters.
#
# @param [Hash] positions_config_hash
#   Describes how to save read file offsets to disk.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md
#   for all parameters.
#
# @param [Hash] scrape_configs_hash
#   Each scrape_config block configures how Promtail can scrape logs from a series of targets
#   using a specified discovery method.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md
#   for all parameters.
#
# @param [Stdlib::Absolutepath] bin_dir
#   The directory in which to create a symlink to the promtail binary
#
# @param [Stdlib::Absolutepath] config_dir
#   The directory in which the promtail config is stored
#
# @param [Stdlib::Absolutepath] data_dir
#   The directory in which to versions of promtail are stored and updated
#
# @param [String[1]] checksum
#   The checksum of the promtail binary.
#   Note: each platform has its own checksum.
#   Values can be found with each release on GitHub
#
# @param [String[1]] version
#   The version as listed on the GitHub release page
#   See https://github.com/grafana/loki/releases for a list
#
# @param [Optional[Hash]] server_config_hash
#   Configures Promtail's behavior as an HTTP server. Defaults will be used if this block
#   is omitted.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md
#   for all parameters.
#
# @param [Optional[Hash]] target_config_hash
#   Configures how tailed targets will be watched. Defaults will be used if this block
#   is omitted.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md
#   for all parameters.
#
# @param [Optional[Stdlib::Absolutepath]] password_file_path
#   The fully qualified path to the file containing the password used for basic auth
#
# @param [Optional[Sensitive[String[1]]]] password_file_content
#   The value to be placed in the password file. This value is cast to Sensitive via
#   lookup_options defined in `data/common.yaml`
#
# @param [Stdlib::HTTPUrl] source_url
#   The URL from which promtail packages can be downloaded
#
# @example
#   include promtail
#
# @example Sample of defining within a profile
#   class { 'promtail':
#     clients_config_hash   => $clients_config_hash,
#     positions_config_hash => $positions_config_hash,
#     scrape_configs_hash   => $_real_scrape_configs_hash,
#     password_file_content => $sensitive_password_file_content,
#     password_file_path    => $password_file_path,
#     service_ensure        => $service_ensure,
#     server_config_hash    => $server_config_hash,
#     target_config_hash    => $target_config_hash,
#     bin_dir               => $bin_dir,
#     checksum              => $checksum,
#     version               => $version,
#   }
#
# @example Settings in a Hiera file
#   ---
#   promtail::password_file_path: '/etc/promtail/.gc_pw'
#   promtail::password_file_content: ENC[PKCS7,MIIBasdfasdfasdfasdfasdfasdf==]
#   promtail::server_config_hash:
#     server:
#       http_listen_port: 9274
#       grpc_listen_port: 0
#   promtail::clients_config_hash:
#     clients:
#       - url: 'https://logs-us-west1.grafana.net/api/prom/push'
#         basic_auth:
#           username: '1234'
#           password_file: '/etc/promtail/.gc_pw'
#   promtail::positions_config_hash:
#     positions:
#       filename: /tmp/positions.yaml
#   promtail::scrape_configs_hash:
#     scrape_configs:
#       - job_name: journal
#         journal:
#           max_age: 12h
#           labels:
#             job: systemd-journal
#             host: "%{facts.networking.fqdn}"
#         relabel_configs:
#           - source_labels:
#               - '__journal__systemd_unit'
#             target_label: 'unit'
#           - source_labels:
#               - 'unit'
#             regex: "session-(.*)"
#             action: replace
#             replacement: 'pam-session'
#             target_label: 'unit'
#
# @example Merging scrape configs in Hiera
#   class profile::logging::promtail {
#     $_real_scrape_configs_hash = lookup('promtail_scrape_configs_hash', {merge => 'deep'})
#     class { 'promtail':
#       scrape_configs_hash => $_real_scrape_configs_hash,
#     }
#   }
#
class promtail (
  Boolean                        $service_enable,
  Enum['running', 'stopped']     $service_ensure,
  Hash                           $clients_config_hash,
  Hash                           $positions_config_hash,
  Hash                           $scrape_configs_hash,
  Stdlib::Absolutepath           $bin_dir               = $promtail::params::bin_dir,
  Stdlib::Absolutepath           $data_dir              = $promtail::params::data_dir,
  Stdlib::Absolutepath           $config_dir            = $promtail::params::config_dir,
  String[1]                      $checksum,
  String[1]                      $version,
  Optional[Hash]                 $server_config_hash    = undef,
  Optional[Hash]                 $target_config_hash    = undef,
  Optional[Stdlib::Absolutepath] $password_file_path    = undef,
  Optional[Sensitive[String[1]]] $password_file_content = undef,
  Stdlib::HTTPUrl                $source_url            = 'https://github.com/grafana/loki/releases/download',
) inherits promtail::params {
  Class['promtail::install']
  -> Class['promtail::config']
  -> Class['promtail::service']

  contain promtail::install
  contain promtail::config
  contain promtail::service
}
