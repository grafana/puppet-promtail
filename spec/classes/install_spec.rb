require 'spec_helper'

describe 'promtail::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with valid params' do
        let(:pre_condition) do
          "class { 'promtail':
            password_file_path    => '/etc/promtail/.gc_pw',
            password_file_content => Sensitive('myPassword'),
            server_config_hash    => {
              'server' => {
                'http_listen_port' => 9274,
                'grpc_listen_port' => 0,
              },
            },
            clients_config_hash => {
              'clients' => [{
                'url'        => 'https://logs-us-west1.grafana.net/api/prom/push',
                'basic_auth' => {
                  'username' => '1234',
                  'password_file' => '/etc/promtail/.gc_pw',
                },
              }],
            },
            positions_config_hash => {
              'positions' => {
                'filename' => '/tmp/positions.yaml',
              },
            },
            scrape_configs_hash => {
              'scrape_configs' => [{
                'job_name'       => 'system_secure',
                'static_configs' => [{
                  'targets' => [ 'localhost' ],
                  'labels'  => {
                    'job'      => 'var_log_secure',
                    'host'     => $facts['networking']['fqdn'],
                    '__path__' => '/var/log/messages',
                  },
                }],
              }],
            },
          }"
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/usr/local/bin/promtail').with_ensure('link') }
        it { is_expected.to contain_file('/usr/local/promtail_data').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/promtail_data/promtail-v2.0.0/promtail-linux-amd64').with_ensure('file') }
        it { is_expected.to contain_file('/usr/local/promtail_data/promtail-v2.0.0').with_ensure('directory') }
        it { is_expected.to contain_archive('/usr/local/promtail_data/promtail-v2.0.0/promtail-linux-amd64.gz') }
        it { is_expected.not_to contain_package('promtail') }
      end

      context 'with package based installation' do
        let(:pre_condition) do
          "class { 'promtail':
            server_config_hash    => {},
            clients_config_hash => {},
            positions_config_hash => {},
            scrape_configs_hash => {},
            install_method => 'package',
          }"
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_file('/usr/local/bin/promtail') }
        it { is_expected.not_to contain_file('/usr/local/promtail_data') }
        it { is_expected.to contain_package('promtail') }
      end
    end
  end
end
