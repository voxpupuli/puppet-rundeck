require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::global::project class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        project_details = {
          'project.dir' => '/var/rundeck/projects/${project.name}',
          'project.etc.dir' => '/var/rundeck/projects/${project.name}/etc',
          'project.resources.file' => '/var/rundeck/projects/${project.name}/etc/resources.xml',
          'project.description' => '',
          'project.organization' => ''
        }

        it { should contain_file('/etc/rundeck/project.properties') }

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
