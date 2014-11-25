require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::global::framework class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily        => osfamily,
          :fqdn            => 'test.domain.com',
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        framework_details = {
          'framework.server.name' => 'test.domain.com',
          'framework.server.hostname' => 'test.domain.com',
          'framework.server.port' => '4440',
          'framework.server.url' => 'http://test.domain.com:4440',
          'framework.server.username' => 'admin',
          'framework.server.password' => 'admin',
          'framework.projects.dir' => '/var/rundeck/projects',
          'framework.etc.dir' => '/etc/rundeck',
          'framework.var.dir' => '/var/lib/rundeck/var',
          'framework.tmp.dir' => '/var/lib/rundeck/var/tmp',
          'framework.logs.dir' => '/var/lib/rundeck/logs',
          'framework.libext.dir' => '/var/lib/rundeck/libext',
          'framework.ssh.keypath' => '/var/lib/rundeck/.ssh/id_rsa',
          'framework.ssh.user' => 'rundeck',
          'framework.ssh.timeout' => '0'
        }

        it { should contain_file('/etc/rundeck/framework.properties') }

        framework_details.each do |key,value|
          it 'should generate valid content for framework.properties' do
            content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
            content.should include("#{key} = #{value}")
          end
        end
      end
    end
  end

  context 'add plugin configuration' do
    describe 'add plugin configuration for the logstash plugin' do
      let(:params) {{
        :framework_config => {
          'framework.plugin.StreamingLogWriter.LogstashPlugin.port' => '9700'
        }
      }}
      let(:facts) {{
        :osfamily        => 'Debian',
        :fqdn            => 'test.domain.com',
        :serialnumber    => 0,
        :rundeck_version => ''
      }}

      it 'should generate valid content for framework.properties' do
        content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
        content.should include('framework.server.name = test.domain.com')
        content.should include('framework.plugin.StreamingLogWriter.LogstashPlugin.port = 9700')
      end
    end
  end
end
