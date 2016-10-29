# rubocop:disable RSpec/MultipleExpectations

require 'spec_helper_acceptance'

describe 'rundeck class' do
  context 'default parameters on ubuntu', if: fact('osfamily').eql?('Debian') do
    it 'works with no errors' do
      pp = <<-EOS
      class { 'java':
        distribution => 'jre'
      }
      class { 'rundeck': }

      Package['openjdk-7-jre-headless'] -> Exec['install rundeck package']
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp, expect_changes: true).exit_code).to eq(2)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_running }
    end
  end

  context 'default parameters on centos', if: fact('osfamily').eql?('RedHat') do
    it 'works with no errors' do
      pp = <<-EOS
      class { 'java':
        distribution => 'jre'
      }
      class { 'rundeck': }

      Package['java-1.7.0-openjdk'] -> Package['rundeck']
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).not_to eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_running }
    end
  end
end
