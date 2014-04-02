require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    SUPPORTED_FAMILIES.each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
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