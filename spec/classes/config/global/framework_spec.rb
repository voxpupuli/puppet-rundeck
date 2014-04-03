require 'spec_helper'

describe 'rundeck::config::global::framework' do
  context 'supported operating systems' do
    SUPPORTED_FAMILIES.each do |osfamily|
      describe "rundeck::config::global::framework class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
            :osfamily => osfamily,
        }}

        framework_details = {
          'framework.server.name' => 'localhost',
          'framework.server.hostname' => 'localhost',
          'framework.server.port' => '4440',
          'framework.server.url' => 'http://localhost:4440',
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
          it { should contain_ini_setting(key).with(
            'path'    => '/etc/rundeck/framework.properties',
            'setting' => key,
            'value'   => value
          ) }
        end

        it { should contain_ini_setting('global rdeck.base').with(
          'path'    => '/etc/rundeck/framework.properties',
          'setting' => 'rdeck.base',
          'value'   => '/var/lib/rundeck'
        ) }

      end
    end
  end
end