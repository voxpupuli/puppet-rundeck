require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck::config::global::project class without any parameters on #{os}" do
        let(:params) { {} }

        project_details = {
          'project.dir' => '/var/lib/rundeck/projects/${project.name}',
          'project.etc.dir' => '/var/lib/rundeck/projects/${project.name}/etc',
          'project.resources.file' => '/var/lib/rundeck/projects/${project.name}/etc/resources.xml',
          'project.description' => '',
          'project.organization' => ''
        }

        it { is_expected.to contain_file('/etc/rundeck/project.properties') }

        project_details.each do |key, value|
          it do
            is_expected.to contain_ini_setting(key).with(
              'path'    => '/etc/rundeck/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end
    end
  end
end
