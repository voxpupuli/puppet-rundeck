# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without any parameters test rundeck::config::framework' do
        let(:params) { {} }

        framework_details = {
          'framework.server.name' => 'foo.example.com',
          'framework.server.hostname' => 'foo',
          'framework.server.port' => '4440',
          'framework.server.url' => 'http://foo.example.com:4440',
          'framework.etc.dir' => '/etc/rundeck',
          'framework.libext.dir' => '/var/lib/rundeck/libext',
          'framework.ssh.keypath' => '/var/lib/rundeck/.ssh/id_rsa',
          'framework.ssh.user' => 'rundeck',
          'framework.ssh.timeout' => '0'
        }

        it { is_expected.to contain_file('/etc/rundeck/framework.properties') }

        framework_details.each do |key, value|
          it 'generates valid content for framework.properties' do
            content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
            expect(content).to include("#{key} = #{value}")
          end
        end
      end

      context 'add plugin configuration for the logstash plugin' do
        let(:params) do
          {
            framework_config: {
              'framework.plugin.StreamingLogWriter.LogstashPlugin.port' => '9700'
            }
          }
        end

        it 'generates valid content for framework.properties' do
          content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
          expect(content).to include('framework.server.name = foo.example.com')
          expect(content).to include('framework.plugin.StreamingLogWriter.LogstashPlugin.port = 9700')
        end
      end

      context 'setting framework.server.{name,url}' do
        context 'with non-default framework.server.url' do
          let(:params) do
            {
              framework_config: {
                'framework.server.url' => 'http://rundeck.example.com:4440'
              }
            }
          end

          it 'generates valid content for framework.properties' do
            content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
            expect(content).to include('framework.server.url = http://rundeck.example.com:4440')
          end
        end

        context 'ssl_enabled with non-default SSL port' do
          let(:params) do
            {
              ssl_enabled: true,
              ssl_port: 443
            }
          end

          it 'generates valid content for framework.properties' do
            content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
            expect(content).to include('framework.server.port = 443')
            expect(content).to include('framework.server.url = https://foo.example.com:443')
          end
        end

        context 'ssl_enabled with non-default framework.server.hostname' do
          let(:params) do
            {
              ssl_enabled: true,
              ssl_port: 443,
              framework_config: {
                'framework.server.name' => 'rundeck.example.com'
              }
            }
          end

          it 'generates valid content for framework.properties' do
            content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
            expect(content).to include('framework.server.port = 443')
            expect(content).to include('framework.server.url = https://rundeck.example.com:443')
          end
        end
      end
    end
  end
end
