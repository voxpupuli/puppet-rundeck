require 'spec_helper'

describe 'rundeck::config::project', :type => :define do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::project definition without any parameters on #{osfamily}" do
        projects_dir = '/var/rundeck/projects'

        let(:title) { 'test' }
        let(:params) do
          {
            :framework_config => {
              'framework.projects.dir' => projects_dir,
              'framework.ssh.keypath'  => '/var/lib/rundeck/.ssh/id_rsa'
            },
            :file_copier_provider => 'jsch-scp',
            :resource_sources => {},
            :node_executor_provider => 'jsch-ssh',
            :user  => 'rundedck',
            :group => 'rundeck'
          }
        end

        let(:facts) do
          {
            :osfamily        => osfamily,
            :serialnumber    => 0,
            :rundeck_version => '',
            :puppetversion   => Puppet.version,
          }
        end

        it do
          should contain_file("#{projects_dir}/test/var").with(
            'ensure' => 'directory'
          )
        end

        it do
          should contain_file("#{projects_dir}/test/etc").with(
            'ensure' => 'directory'
          )
        end

        it { should contain_file("#{projects_dir}/test/etc/project.properties") }

        project_details = {
          'project.name' => 'test',
          'project.ssh-authentication' => 'privateKey',
          'project.ssh-keypath' => '/var/lib/rundeck/.ssh/id_rsa',
          'service.NodeExecutor.default.provider' => 'jsch-ssh',
          'service.FileCopier.default.provider' => 'jsch-scp'
        }

        project_details.each do |key, value|
          it do
            should contain_ini_setting("test::#{key}").with(
              'path'    => '/var/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end
    end
  end
end
