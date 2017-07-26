require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck class without any parameters on #{os}" do
        let(:params) { {} }

        it { is_expected.to contain_service('rundeckd') }
      end
    end
  end
end
