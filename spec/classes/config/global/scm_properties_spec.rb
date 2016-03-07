require 'spec_helper'

describe 'rundeck' do
  let(:facts) do
    {
      :osfamily        => 'Debian',
      :fqdn            => 'test.domain.com',
      :serialnumber    => 0,
      :rundeck_version => '',
      :puppetversion   => Puppet.version
    }
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
        }
      }
    }
    let(:params) do
      {
        :projects => project_hash
      }
    end

    # content and meta data for passwords
    it { should contain_file('/var/lib/rundeck/projects/project_1/etc/scm-import.properties') }
    project_hash['project_1']['scm_import_properties'].each do |key, value|
      it 'should generate valid content for scm-import.properties' do
        content = catalogue.resource('file', '/var/lib/rundeck/projects/project_1/etc/scm-import.properties')[:content]
        expect(content).to include("#{key} = #{value}")
      end
    end
  end
end
