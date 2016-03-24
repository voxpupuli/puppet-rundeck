require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::framework class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            :osfamily        => osfamily,
            :fqdn            => 'test.domain.com',
            :serialnumber    => 0,
            :rundeck_version => '',
            :puppetversion   => Puppet.version
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

        it { should contain_concat('/etc/rundeck/framework.properties') }

        framework_details.each do |key, value|
          it 'should generate valid content for framework.properties' do
            content = catalogue.resource('concat::fragment', 'framework.properties+10_main')[:content]
            expect(content).to match(/^#{key}\ *=\ *#{value}$/)
          end
        end
      end
    end
  end
end
