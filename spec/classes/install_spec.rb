require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck class without any parameters on #{os}" do
        let(:params) { {} }

        it { is_expected.not_to contain_user('rundeck') }
        it do
          is_expected.to contain_file('/var/rundeck').with(
            ensure: 'directory',
            owner: 'rundeck',
            group: 'rundeck',
            recurse: true
          )
        end

        case facts[:os]['family']
        when 'RedHat'
          it do
            is_expected.to contain_yumrepo('rundeck').with(
              baseurl: "https://packagecloud.io/pagerduty/rundeck/rpm_any/rpm_any/\$basearch",
              gpgcheck: 0,
              repo_gpgcheck: 1,
              gpgkey: 'https://packagecloud.io/pagerduty/rundeck/gpgkey'
            ).that_comes_before('Package[rundeck]')
          end
        when 'Debian'
          it { is_expected.to contain_apt__source('rundeck').with_location('https://packagecloud.io/pagerduty/rundeck/any') }
          it { is_expected.to contain_package('rundeck').that_notifies('Class[rundeck::service]') }
          it { is_expected.to contain_package('rundeck').that_requires('Class[apt::update]') }
        end
      end
      describe 'different user and group' do
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
      describe 'different user and group with ids' do
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
