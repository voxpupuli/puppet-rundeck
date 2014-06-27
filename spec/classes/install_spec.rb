require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    SUPPORTED_FAMILIES.each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        if osfamily.eql?('RedHat')
          it { should contain_yumrepo('bintray-rundeck') }
        else
          it { should contain_exec('download rundeck package') }
          it { should contain_exec('install rundeck package') }
          it { should_not contain_yumrepo('bintray-rundeck') }
        end

      end
    end
  end
end
