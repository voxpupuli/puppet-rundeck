# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'rundeck class' do
  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'java':
          distribution => 'jre',
        }
        class { 'rundeck':
          package_ensure => '5.0.2.20240212-1',
        }
        Class['java'] -> Class['rundeck']
        PUPPET
      end
    end
    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'updrade to 5.2.0.20240410-1' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
         class { 'rundeck':
          package_ensure => '5.2.0.20240410-1',
        }
        PUPPET
      end
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'updrade to 5.7.0.20241021-1' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
         class { 'rundeck':
          package_ensure => '5.7.0.20241021-1',
        }
        PUPPET
      end
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
