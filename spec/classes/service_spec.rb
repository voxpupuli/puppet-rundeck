# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default parameters test rundeck::service' do
        it { is_expected.to contain_service('rundeckd').with(ensure: 'running') }
      end
    end
  end
end
