require 'spec_helper'

describe 'rundeck::config::global::project' do
  context 'supported operating systems' do
    SUPPORTED_FAMILIES.each do |osfamily|
      describe "rundeck::config::global::project class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
            :osfamily => osfamily,
        }}

        project_details = {
          'project.dir' => '/var/rundeck/projects/${project.name}',
          'project.etc.dir' => '/var/rundeck/projects/${project.name}/etc',
          'project.resources.file' => '/var/rundeck/projects/${project.name}/etc/resources.xml',
          'project.description' => '',
          'project.organization' => ''
        }

        project_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/etc/rundeck/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end

      end
    end
  end
end