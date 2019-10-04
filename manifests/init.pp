# @summary promtail's main interface. All interactions should be with this class.
#
# promtail's main interface. All interactions should be with this class. The promtail
# module is intended to install and configure Grafana's promtail tool for shipping
# logs to Loki.
#
# @param [Hash] config_hash
#   A hash representing the configuration to be used by promtail.
#   See https://github.com/grafana/loki/blob/master/docs/clients/promtail/configuration.md#example-journal-config
#   for all paramters.
# @param [Stdlib::Absolutepath] bin_dir
#   The directory in which to create a symlink to the promtail binary
# @param [String[1]] checksum
#   The checksum of the promtail binary.
#   Note: each platform has its own checksum.
#   Values can be found with each release on GitHub
# @param [String[1]] version
#   The version as listed on the GitHub release page
#   See https://github.com/grafana/loki/releases for a list
# @param [Optional[Stdlib::Absolutepath]] $password_file_path
#   The fully qualified path to the file containing the password used for basic auth
# @param [Optional[Sensitive[String[1]]]] $password_file_content
#   The value to be placed in the password file.
#
# @example Config settings in Hiera
#   include promtail
#
# @example eyaml encrypted password in Hiera
#   ---
#   lookup_options:
#     '^promtail::password_file_content$':
#       convert_to: 'Sensitive'
#
#   promtail::password_file_content: ENC[PKCS7,MIIBasdfasdfasdfasdfasdfasdf==]
#
# @example In-manifest config
#   $config_hash = {
#     'client'         => {
#       'url'        => 'https://logs-us-west1.grafana.net/api/prom/push',
#       'basic_auth' => {
#         'username'      => '1234',
#         'password_file' => '/etc/promtail/.gc_pw',
#       },
#     },
#     'scrape_configs' => [
#       {
#         'job_name'       => 'system',
#         'entry_parser'   => 'raw',
#         'static_configs' => [
#           {
#             'targets' => [ 'localhost' ],
#             'labels'  => {
#               'job'      => 'var_log_messages',
#               'host'     => $facts['networking']['fqdn'],
#               '__path__' => '/var/log/messages',
#             },
#           },
#         ],
#       },
#     ],
#   }
#
#   class { 'promtail':
#     config_hash           => $config_hash,
#     password_file_path    => '/etc/promtail/.gc_pw',
#     password_file_content => Sensitive('myPassword'),
#   }
#
class promtail (
  Hash $config_hash,
  Stdlib::Absolutepath $bin_dir,
  String[1] $checksum,
  String[1] $version,
  Optional[Stdlib::Absolutepath] $password_file_path = undef,
  Optional[Sensitive[String[1]]] $password_file_content = undef,
){
  Class['promtail::install']
  -> Class['promtail::config']
  -> Class['promtail::service']

  contain promtail::install
  contain promtail::config
  contain promtail::service
}
