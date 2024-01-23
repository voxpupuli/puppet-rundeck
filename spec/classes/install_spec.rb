# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'without any parameters test rundeck::install' do
        let(:params) { {} }

        it { is_expected.not_to contain_user('rundeck') }

        case facts[:os]['family']
        when 'RedHat'
          it do
            is_expected.to contain_yumrepo('rundeck').with(
              baseurl: 'https://packages.rundeck.com/pagerduty/rundeck/rpm_any/rpm_any/$basearch',
              repo_gpgcheck: 1,
              gpgcheck: 0,
              enabled: 1,
              gpgkey: 'https://packages.rundeck.com/pagerduty/rundeck/gpgkey'
            ).that_comes_before('Package[rundeck]')
          end
        when 'Debian'
          it do
            is_expected.to contain_apt__source('rundeck').with(
              location: 'https://packages.rundeck.com/pagerduty/rundeck/any',
              release: 'any',
              repos: 'main',
              key: {
                'id' => '0DDD2FA79B15D736ECEA32B89B5206167C5C34C0',
                'server' => 'keyserver.ubuntu.com',
              }
            )
          end

          it { is_expected.to contain_class('apt::update').that_comes_before('Package[rundeck]') }
        end

        it { is_expected.to contain_package('rundeck').that_notifies('Class[rundeck::service]') }
      end

      context 'with different user and group' do
        let(:params) do
          {
            manage_user: true,
            manage_group: true,
            user: 'A1234',
            group: 'A1234'
          }
        end

        it { is_expected.to contain_group('A1234').with('ensure' => 'present') }

        it { is_expected.to contain_group('rundeck').with('ensure' => 'absent') }

        it { is_expected.to contain_user('A1234').with('ensure' => 'present') }

        it { is_expected.to contain_user('rundeck').with('ensure' => 'absent') }
      end

      context 'different user and group with ids' do
        let(:params) do
          {
            manage_user: true,
            manage_group: true,
            user: 'A1234',
            group: 'A1234',
            user_id: 10_000,
            group_id: 10_000
          }
        end

        it do
          is_expected.to contain_group('A1234').with(
            'ensure' => 'present',
            'gid' => 10_000
          )
        end

        it do
          is_expected.to contain_user('A1234').with(
            'ensure' => 'present',
            'gid' => '10000',
            'uid' => '10000'
          )
        end
      end
    end
  end
end
