# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default parameters test rundeck' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('rundeck::install').that_comes_before('Class[rundeck::config]') }
        it { is_expected.to contain_class('rundeck::config').that_notifies('Class[rundeck::service]') }
        it { is_expected.to contain_class('rundeck::service') }
        it { is_expected.to contain_class('rundeck::config::jaas_auth') }
        it { is_expected.to contain_class('rundeck::config::framework') }
        it { is_expected.not_to contain_class('rundeck::config::ssl') }
        it { is_expected.to contain_class('rundeck::cli') }
      end

      context 'with service_notify => false' do
        let(:params) do
          {
            service_notify: false
          }
        end

        it { is_expected.to contain_class('rundeck::install').that_comes_before('Class[rundeck::config]') }
        it { is_expected.to contain_class('rundeck::config').that_comes_before('Class[rundeck::service]') }
        it { is_expected.to contain_class('rundeck::service') }
        it { is_expected.to contain_class('rundeck::cli') }
      end

      context 'with ssl_enabled => true' do
        let(:params) do
          {
            ssl_enabled: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('rundeck::config::ssl') }
      end

      context 'override server uuid' do
        let :facts do
          # uuid is ac7c2cbd-14fa-5ba3-b3f2-d436e9b8a3b0
          override_facts(super(), networking: { fqdn: 'rundeck.example.com' })
        end

        it { is_expected.to contain_file('/etc/rundeck/framework.properties') }

        it 'uses fqdn fact for \'rundeck.server.uuid\'' do
          content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
          expect(content).to include('rundeck.server.uuid = ac7c2cbd-14fa-5ba3-b3f2-d436e9b8a3b0')
        end
      end

      context 'with manage_cli => false' do
        let(:params) do
          {
            manage_cli: false
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('rundeck::cli') }
      end
    end
  end
end
