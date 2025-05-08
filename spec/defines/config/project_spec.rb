# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck::config::project', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'Add rundeck project: MyProject with defaults' do
        name = 'MyProject'

        let(:title) { name }

        it do
          is_expected.to contain_rundeck__config__project('MyProject').with(
            ensure: 'present',
            update_method: 'update',
            config: {
              'project.description' => 'MyProject project',
              'project.label' => 'MyProject',
              'project.disable.executions' => 'false',
              'project.disable.schedule' => 'false',
              'project.execution.history.cleanup.batch' => '500',
              'project.execution.history.cleanup.enabled' => 'true',
              'project.execution.history.cleanup.retention.days' => '60',
              'project.execution.history.cleanup.retention.minimum' => '50',
              'project.execution.history.cleanup.schedule' => '0 0 0 1/1 * ? *',
              'project.jobs.gui.groupExpandLevel' => '1',
            }
          )
        end

        it { is_expected.to contain_exec('Create rundeck project: MyProject') }
        it { is_expected.to contain_exec('Manage rundeck project: MyProject') }
      end

      context 'Add rundeck project: TestProject with update_method = set and custom config' do
        name = 'TestProject'

        let(:title) { name }
        let(:params) do
          {
            update_method: 'set',
            config: {
              'project.description' => 'This is a rundeck test project',
              'project.disable.executions' => 'false',
            },
          }
        end

        it do
          is_expected.to contain_rundeck__config__project('TestProject').with(
            ensure: 'present',
            update_method: 'set',
            config: {
              'project.description' => 'This is a rundeck test project',
              'project.disable.executions' => 'false',
            }
          )
        end

        it { is_expected.to contain_exec('Create rundeck project: TestProject') }
        it { is_expected.to contain_exec('Manage rundeck project: TestProject') }
      end

      context 'Remove rundeck project: RemoveProject' do
        name = 'RemoveProject'

        let(:title) { name }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_rundeck__config__project('RemoveProject').with(ensure: 'absent') }
        it { is_expected.to contain_exec('Remove rundeck project: RemoveProject') }
      end

      context 'Add rundeck project: MyJobProject with jobs' do
        name = 'MyJobProject'

        let(:title) { name }
        let(:params) do
          {
            config: {
              'project.description'      => 'This is a rundeck project with jobs',
              'project.disable.schedule' => 'true',
            },
            jobs: {
              'MyJob1' => {
                'path'   => '/etc/myjob1',
                'format' => 'yaml',
              },
              'MyJob2' => {
                'path'   => '/etc/myjob2',
                'format' => 'xml',
              },
              'TestJob1' => {
                'path'   => '/etc/testjob1',
                'format' => 'yaml',
              },
              'DeleteJob1' => {
                'ensure' => 'absent',
                'path'   => '/etc/testjob1',
                'format' => 'yaml',
              },
            },
          }
        end

        it do
          is_expected.to contain_rundeck__config__project('MyJobProject').with(
            ensure: 'present',
            update_method: 'update',
            config: {
              'project.description' => 'This is a rundeck project with jobs',
              'project.disable.schedule' => 'true',
            },
            jobs: {
              'MyJob1' => {
                'path'   => '/etc/myjob1',
                'format' => 'yaml',
              },
              'MyJob2' => {
                'path'   => '/etc/myjob2',
                'format' => 'xml',
              },
              'TestJob1' => {
                'path'   => '/etc/testjob1',
                'format' => 'yaml',
              },
              'DeleteJob1' => {
                'ensure' => 'absent',
                'path'   => '/etc/testjob1',
                'format' => 'yaml',
              }
            }
          )
        end

        it { is_expected.to contain_exec('Create rundeck project: MyJobProject') }
        it { is_expected.to contain_exec('Manage rundeck project: MyJobProject') }
        it { is_expected.to contain_exec('(MyJobProject) Create/update job: MyJob1') }
        it { is_expected.to contain_exec('(MyJobProject) Create/update job: MyJob2') }
        it { is_expected.to contain_exec('(MyJobProject) Create/update job: TestJob1') }
        it { is_expected.to contain_exec('(MyJobProject) Remove job: DeleteJob1') }
      end

      context 'Add rundeck project: TestSCM with scm config' do
        name = 'TestSCM'

        let(:title) { name }
        let(:params) do
          {
            scm_config: {
              'import' => {
                'type'   => 'git-import',
                'config' => {
                  'strictHostKeyChecking' => 'yes',
                  'gitPasswordPath'       => 'keys/example-access-token',
                  'format'                => 'xml',
                  'dir'                   => '/var/lib/rundeck/projects/MyProject/ScmImport',
                  'branch'                => 'master',
                  'url'                   => 'https://myuser@example.com/example/example.git',
                  'filePattern'           => '*.xml',
                  'useFilePattern'        => 'true',
                  'pathTemplate'          => '${job.id}.${config.format}',
                  'importUuidBehavior'    => 'preserve',
                  'sshPrivateKeyPath'     => '',
                  'fetchAutomatically'    => 'true',
                  'pullAutomatically'     => 'true',
                },
              },
            },
          }
        end

        it { is_expected.to contain_exec('Create rundeck project: TestSCM') }
        it { is_expected.to contain_exec('Manage rundeck project: TestSCM') }
        it { is_expected.to contain_file('/var/lib/rundeck/projects/TestSCM').with(ensure: 'directory', owner: 'rundeck', group: 'rundeck', mode: '0755') }
        it { is_expected.to contain_file('/var/lib/rundeck/projects/TestSCM/scm-import.json').with(ensure: 'file', owner: 'rundeck', group: 'rundeck', mode: '0644') }
        it { is_expected.to contain_exec('Setup/update/enable SCM import for rundeck project: TestSCM').that_requires('File[/var/lib/rundeck/projects/TestSCM/scm-import.json]') }
      end

      context 'Add rundeck project: TestWrongSCM with wrong scm config' do
        name = 'TestWrongSCM'

        let(:title) { name }
        let(:params) do
          {
            scm_config: {
              'wrong_key' => {
                'type'   => 'git-import',
                'config' => {
                  'strictHostKeyChecking' => 'yes',
                  'gitPasswordPath'       => 'keys/example-access-token',
                  'format'                => 'xml',
                  'dir'                   => '/var/lib/rundeck/projects/MyProject/ScmImport',
                  'branch'                => 'master',
                  'url'                   => 'https://myuser@example.com/example/example.git',
                  'filePattern'           => '*.xml',
                  'useFilePattern'        => 'true',
                  'pathTemplate'          => '${job.id}.${config.format}',
                  'importUuidBehavior'    => 'preserve',
                  'sshPrivateKeyPath'     => '',
                  'fetchAutomatically'    => 'true',
                  'pullAutomatically'     => 'true',
                },
              },
            },
          }
        end

        it { is_expected.not_to compile }
      end
    end
  end
end
