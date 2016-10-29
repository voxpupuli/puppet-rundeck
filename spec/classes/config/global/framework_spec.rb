# rubocop:disable RSpec/MultipleExpectations

require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::framework class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            fqdn: 'test.domain.com',
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        framework_details = {
          'framework.server.name' => 'test.domain.com',
          'framework.server.hostname' => 'test.domain.com',
          'framework.server.port' => '4440',
          'framework.server.url' => 'http://test.domain.com:4440',
          'framework.server.username' => 'admin',
          'framework.server.password' => 'admin',
          'framework.projects.dir' => '/var/lib/rundeck/projects',
          'framework.etc.dir' => '/etc/rundeck',
          'framework.var.dir' => '/var/lib/rundeck/var',
          'framework.tmp.dir' => '/var/lib/rundeck/var/tmp',
          'framework.logs.dir' => '/var/lib/rundeck/logs',
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
    end
  end

  context 'add plugin configuration' do
    describe 'add plugin configuration for the logstash plugin' do
      let(:params) do
        {
          framework_config: {
            'framework.plugin.StreamingLogWriter.LogstashPlugin.port' => '9700'
          }
        }
      end
      let(:facts) do
        {
          osfamily: 'Debian',
          fqdn: 'test.domain.com',
          serialnumber: 0,
          rundeck_version: '',
          puppetversion: Puppet.version
        }
      end

      it 'generates valid content for framework.properties' do
        content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
        expect(content).to include('framework.server.name = test.domain.com')
        expect(content).to include('framework.plugin.StreamingLogWriter.LogstashPlugin.port = 9700')
      end
    end
  end
  context 'add port and url configuration' do
    describe 'with ssl true' do
      let(:params) do
        {
          ssl_enabled: true,
          ssl_port: '443'
        }
      end
      let(:facts) do
        {
          osfamily: 'Debian',
          fqdn: 'test.domain.com',
          serialnumber: 0,
          rundeck_version: '',
          puppetversion: Puppet.version
        }
      end

      it 'generates valid content for framework.properties framework.server.port = 443 and framework.server.url = https://test.domain.com:443' do
        content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
        expect(content).to include('framework.server.port = 443')
        expect(content).to include('framework.server.url = https://test.domain.com:443')
      end
    end
  end
end
