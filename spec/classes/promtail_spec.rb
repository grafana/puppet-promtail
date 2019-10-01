require 'spec_helper'

describe 'promtail' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'with valid params' do
        let(:facts) { os_facts }
        let(:params) do
          {
            'config_hash' => {
              'client' => {
                'url'        => 'https://logs-us-west1.grafana.net/api/prom/push',
                'basic_auth' => {
                  'username'      => '1234',
                  'password_file' => '/etc/promtail/.gc_pw',
                },
              },
              'scrape_configs' => [
                {
                  'job_name'       => 'system',
                  'entry_parser'   => 'raw',
                  'static_configs' => [
                    {
                      'targets' => ['localhost'],
                      'labels'  => {
                        'job'      => 'var_log_messages',
                        'host'     => "${facts['networking']['fqdn']}",
                        '__path__' => '/var/log/messages',
                      },
                    },
                  ],
                },
              ],
            },
            'password_file_path' => '/etc/promtail/.gc_pw',
            'password_file_content' => RSpec::Puppet::RawString.new("Sensitive('myPassword')"),
          }
        end

        it { is_expected.to compile }
      end
      context 'without a config_hash provided' do
        let(:facts) { os_facts }

        it { is_expected.to compile.and_raise_error(%r{expects a value for parameter 'config_hash'}) }
      end
    end
  end
end
