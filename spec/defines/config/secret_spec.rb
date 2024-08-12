# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck::config::secret', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          'content' => 'very_secure_secret',
        }
      end

      context 'Add rundeck password: keys/myuser with defaults' do
        name = 'keys/myuser'

        let(:title) { name }

        it { is_expected.to contain_file('/var/lib/rundeck/keystorage').with(ensure: 'directory', owner: 'rundeck', group: 'rundeck', mode: '0755') }

        it do
          is_expected.to contain_file('/var/lib/rundeck/keystorage/myuser.password').with(
            ensure: 'present',
            owner: 'rundeck',
            group: 'rundeck',
            mode: '0400',
            content: 'very_secure_secret'
          )
        end

        it { is_expected.to contain_exec('Create rundeck password: keys/myuser') }
        it { is_expected.to contain_exec('Update rundeck password: keys/myuser') }
      end

      context 'Add rundeck privateKey: keys/mykey' do
        name = 'keys/mykey'

        let(:title) { name }
        let(:params) do
          super().merge(
            'type' => 'privateKey'
          )
        end

        it { is_expected.to contain_file('/var/lib/rundeck/keystorage').with(ensure: 'directory', owner: 'rundeck', group: 'rundeck', mode: '0755') }

        it do
          is_expected.to contain_file('/var/lib/rundeck/keystorage/mykey.privateKey').with(
            ensure: 'present',
            owner: 'rundeck',
            group: 'rundeck',
            mode: '0400',
            content: 'very_secure_secret'
          )
        end

        it { is_expected.to contain_exec('Create rundeck privateKey: keys/mykey') }
        it { is_expected.to contain_exec('Update rundeck privateKey: keys/mykey') }
      end

      context 'Remove rundeck password: keys/myuser2 with defaults' do
        name = 'keys/myuser2'

        let(:title) { name }
        let(:params) do
          super().merge(
            'ensure' => 'absent'
          )
        end

        it { is_expected.to contain_file('/var/lib/rundeck/keystorage').with(ensure: 'directory', owner: 'rundeck', group: 'rundeck', mode: '0755') }

        it do
          is_expected.to contain_file('/var/lib/rundeck/keystorage/myuser2.password').with(
            ensure: 'absent',
            owner: 'rundeck',
            group: 'rundeck',
            mode: '0400',
            content: 'very_secure_secret'
          )
        end

        it { is_expected.to contain_exec('Remove rundeck password: keys/myuser2') }
      end
    end
  end
end
