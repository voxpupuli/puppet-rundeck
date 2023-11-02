# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      describe 'with empty params' do
        let(:params) do
          {}
        end

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').that_notifies('Service[rundeckd]') }
      end

      describe 'with service_restart false' do
        let(:params) do
          {
            service_restart: false
          }
        end

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').without_notify }
      end
    end
  end
end
