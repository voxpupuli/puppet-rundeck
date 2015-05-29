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

    describe package('openjdk-7-jre') do
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

    describe package('java-1.7.0-openjdk') do
      it { should be_installed }
    end

    describe package('rundeck') do
      it { should be_installed }
    end

    describe service('rundeckd') do
      it { should be_running }
    end
  end

  context 'different jre version on ubuntu', :if => fact('osfamily').eql?('Debain') do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'rundeck':
        jre_name    => 'openjdk-8-jre',
        jre_ensure  => '8u45-b14-1~12.04'
      }
      EOS
      
      on host, "apt-get -q -y install python-software-properties"
      on host, "add-apt-repository ppa:openjdk-r/ppa -y"
      on host, "apt-get update"

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
