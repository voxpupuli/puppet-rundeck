# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'rundeck class' do
  context 'default parameters' do
    it 'applies successfully' do
      pp = <<-EOS
      class { 'java':
        distribution => 'jre',
      }
      class { 'rundeck':
        package_ensure => '5.0.2.20240212-1',
      }

      Class['java'] -> Class['rundeck']
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true, debug: true)
      apply_manifest(pp, catch_changes: true, debug: true)
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'updrade to latest version' do
    it 'applies successfully' do
      pp = <<-EOS
      class { 'rundeck':
        package_ensure => '5.2.0.20240410-1',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
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
