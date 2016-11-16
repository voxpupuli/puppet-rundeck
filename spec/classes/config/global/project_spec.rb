require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::project class without any parameters on #{osfamily}" do
        lsbdistid = 'debian' if osfamily.eql?('Debian')

        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            lsbdistid: lsbdistid,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

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
