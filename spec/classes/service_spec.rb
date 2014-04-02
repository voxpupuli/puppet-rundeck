require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    SUPPORTED_FAMILIES.each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
            :osfamily => osfamily,
        }}
        it { should contain_service('rundeckd') }
      end
    end
  end
end