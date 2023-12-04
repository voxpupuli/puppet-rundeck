# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'without any parameters test rundeck::service' do
        let(:params) { {} }

        it { is_expected.to contain_service('rundeckd') }
      end
    end
  end
end
