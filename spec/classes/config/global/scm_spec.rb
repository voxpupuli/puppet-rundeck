require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe 'add scm properties to project' do
        project_hash = {
          'project_1' => {
            'scm_import_properties' => {
              'scm.import.config.useFilePattern'        => 'true',
              'scm.import.config.strictHostKeyChecking' => 'no',
              'scm.import.config.filePattern'           => 'SBO/*',
              'scm.import.config.url'                   => 'git.repo.com/project_1.jobs.git',
              'scm.import.config.format'                => 'yaml',
              'scm.import.config.dir'                   => '/var/lib/rundeck/projects/proect_1/scm',
              'scm.import.config.pathTemplate'          => '${job.project}/${job.group}${job.name}-${job.id}.${config.format}',
              'scm.import.config.sshPrivateKeyPath'     => '',
              'scm.import.config.gitPasswordPath'       => '',
              'scm.import.config.branch'                => 'master',
              'scm.import.enabled'                      => 'false',
              'scm.import.roles.0'                      => 'user',
              'scm.import.type'                         => 'git-import',
              'scm.import.username'                     => '',
              'scm.import.roles.count'                  => '3',
              'scm.import.trackedItems.count'           => '0'
            },
            'scm_export_properties' => {
              'scm.export.enabled'                      => 'false',
              'scm.export.config.format'                => 'yaml',
              'scm.export.config.dir'                   => '/var/lib/rundeck/projects/project_1/scm',
              'scm.export.config.url'                   => 'git.repo.com/project_1.jobs.git',
              'scm.export.config.branch'                => 'master',
              'scm.export.config.pathTemplate'          => '{job.project}/${job.group}${job.name}-${job.id}.${config.format}',
              'scm.export.config.strictHostKeyChecking' => 'no',
              'scm.export.config.gitPasswordPath'       => '',
              'scm.export.config.sshPrivateKeyPath'     => 'keys/${project}/users/scm/${user.login}.private',
              'scm.export.roles.count'                  => '2',
              'scm.export.roles.1'                      => 'user',
              'scm.export.type'                         => 'git-export',
              'scm.export.username'                     => '${user.username}',
              'scm.export.config.committerName'         => '${user.fullName}',
              'scm.export.config.committerEmail'        => '${user.email}'
            }
          }
        }
        let(:params) do
          {
            projects: project_hash
          }
        end

        # content and meta data for passwords
        it { is_expected.to contain_file('/var/lib/rundeck/projects/project_1/etc/scm-import.properties') }
        project_hash['project_1']['scm_import_properties'].each do |key, value|
          it 'generates valid content for scm-import.properties' do
            content = catalogue.resource('file', '/var/lib/rundeck/projects/project_1/etc/scm-import.properties')[:content]
            expect(content).to include("#{key} = #{value}")
          end
        end
        project_hash['project_1']['scm_export_properties'].each do |key, value|
          it 'generates valid content for scm-export.properties' do
            content = catalogue.resource('file', '/var/lib/rundeck/projects/project_1/etc/scm-export.properties')[:content]
            expect(content).to include("#{key} = #{value}")
          end
        end
      end
    end
  end
end
