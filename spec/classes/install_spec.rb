require 'spec_helper'

describe 'rundeck::install' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "rundeck::install class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should contain_exec('download rundeck package') }
        it { should contain_exec('install rundeck package') }

        if osfamily.eql?('RedHat')
          it { should contain_exec('download rundeck-config package') }
        else
          it { should_not contain_exec('download rundeck-config package') }
        end

      end
    end
  end
end