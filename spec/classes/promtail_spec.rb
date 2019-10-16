require 'spec_helper'

describe 'promtail' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'with valid params' do
        let(:facts) { os_facts }
        let(:params) do
          {
            'password_file_path'    => '/etc/promtail/.gc_pw',
            'password_file_content' => RSpec::Puppet::RawString.new("Sensitive('myPassword')"),
            'server_config_hash'    => {
              'server' => {
                'http_listen_port' => 9274,
                'grpc_listen_port' => 0,
              },
            },
            'clients_config_hash' => {
              'clients' => [{
                'url'        => 'https://logs-us-west1.grafana.net/api/prom/push',
                'basic_auth' => {
                  'username' => '1234',
                  'password_file' => '/etc/promtail/.gc_pw',
                },
              }],
            },
            'positions_config_hash' => {
              'positions' => {
                'filename' => '/tmp/positions.yaml',
              },
            },
            'scrape_configs_hash' => {
              'scrape_configs' => [{
                'job_name'       => 'system_secure',
                'entry_parser'   => 'raw',
                'static_configs' => [{
                  'targets' => ['localhost'],
                  'labels'  => {
                    'job'      => 'var_log_secure',
                    'host'     => "$facts['networking']['fqdn']",
                    '__path__' => '/var/log/messages',
                  },
                }],
              }],
            },
          }
        end

        it { is_expected.to compile }
      end
      context 'without a config_hash provided' do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include promtail' }

        it { is_expected.to compile.and_raise_error(%r{expects a value for parameter 'clients_config_hash'}) }
        it { is_expected.to compile.and_raise_error(%r{expects a value for parameter 'positions_config_hash'}) }
        it { is_expected.to compile.and_raise_error(%r{expects a value for parameter 'scrape_configs_hash'}) }
      end
    end
  end
end
