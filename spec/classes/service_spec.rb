require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
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
