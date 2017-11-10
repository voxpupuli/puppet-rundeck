require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck class without any parameters on #{os}" do
        let(:params) { {} }

        plugin_dir = '/var/lib/rundeck/libext'

        it { is_expected.to contain_file('/var/lib/rundeck').with('ensure' => 'directory') }

        it { is_expected.to contain_file(plugin_dir).with('ensure' => 'directory') }

        it { is_expected.to contain_user('rundeck').with('ensure' => 'present') }

        case facts[:os]['family']
        when 'RedHat'
          it do
            is_expected.to contain_yumrepo('bintray-rundeck').with(
              baseurl: 'http://dl.bintray.com/rundeck/rundeck-rpm/',
              gpgcheck: 1,
              gpgkey: 'https://bintray.com/user/downloadSubjectPublicKey?username=rundeck'
            ).that_comes_before('Package[rundeck]')
          end
        when 'Debian'
          it { is_expected.to contain_apt__source('bintray-rundeck').with_location('https://dl.bintray.com/rundeck/rundeck-deb') }
          it { is_expected.to contain_package('rundeck').that_notifies('Class[rundeck::service]') }
          it { is_expected.to contain_package('rundeck').that_requires('Class[apt::update]') }
        end
      end
      describe 'different user and group' do
        let(:params) do
          {
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
