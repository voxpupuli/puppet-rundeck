require 'spec_helper_acceptance'

describe 'rundeck class' do

  context 'default parameters on ubuntu', :if => fact('osfamily').eql?('Debian') do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'rundeck': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('openjdk-6-jre') do
      it { should be_installed }
    end

    describe package('rundeck') do
      it { should be_installed }
    end

    describe service('rundeckd') do
      it { should be_running }
    end
  end

  context 'default parameters on centos', :if => fact('osfamily').eql?('RedHat') do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'rundeck': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('java-1.6.0-openjdk') do
      it { should be_installed }
    end

    describe package('rundeck') do
      it { should be_installed }
    end

    describe service('rundeckd') do
      it { should be_running }
    end
  end

  context 'older package version', :if => fact('osfamily').eql?('Debian') do
    it 'should work with no errors' do

      puppet('resource', 'package', 'rundeck', 'ensure=absent')

      pp = <<-EOS
      class { 'rundeck':
        package_ensure => '2.0.0-1-GA'
      }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('rundeck') do
      it { should be_installed.with_version('2.0.0') }
    end
  end

  context 'older package version', :if => fact('osfamily').eql?('RedHat') do
    it 'should work with no errors' do

      puppet('resource', 'package', 'rundeck', 'ensure=absent')

      pp = <<-EOS
        class { 'rundeck':
          package_ensure => '2.0.0-1.8.GA'
        }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('rundeck') do
      it { should be_installed.with_version('2.0.0') }
    end
  end

  context 'different jre version on ubuntu', :if => fact('osfamily').eql?('Debain') do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'rundeck':
        jre_name    => 'openjdk-7-jre',
        jre_ensure  => '7u51-2.4.4-0ubuntu0.12.04.2'
      }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end

  context 'different jre version on centos', :if => fact('osfamily').eql?('RedHat') do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'rundeck':
        jre_name    => 'java-1.7.0-openjdk',
        jre_ensure  => '1.7.0.51-2.4.4.1.el6_5'
      }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end
