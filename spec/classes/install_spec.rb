require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}
        plugin_dir = '/var/lib/rundeck/libext'

        if osfamily.eql?('RedHat')
          it { should contain_yumrepo('bintray-rundeck') }
        else
          it { should contain_exec('download rundeck package') }
          it { should contain_exec('install rundeck package') }
          it { should_not contain_yumrepo('bintray-rundeck') }
        end

          it { should contain_file('/var/rundeck').with(
            'ensure' => 'directory'
          ) }
          
          it { should contain_file(plugin_dir).with(
          'ensure' => 'directory'
          ) } 

     end
    end
  end
end
