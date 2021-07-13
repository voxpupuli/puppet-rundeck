require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      overrides = '/etc/default/rundeckd'
      overrides = '/etc/sysconfig/rundeckd' if %w[RedHat Amazon].include? facts[:os]['family']

      let :facts do
        facts
      end

      describe "rundeck::config class without any parameters on #{os}" do
        it { is_expected.to contain_file('/var/lib/rundeck').with('ensure' => 'directory') }
        it { is_expected.to contain_file('/var/lib/rundeck/libext').with('ensure' => 'directory') }
        it { is_expected.to contain_class('rundeck::config::global::framework') }
        it { is_expected.to contain_class('rundeck::config::global::project') }
        it { is_expected.to contain_class('rundeck::config::global::rundeck_config') }

        it { is_expected.to contain_file('/etc/rundeck').with('ensure' => 'directory') }

        it { is_expected.to contain_file('/etc/rundeck/jaas-auth.conf') }
        it 'generates valid content for jaas-auth.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(content).to include('PropertyFileLoginModule')
          expect(content).to include('/etc/rundeck/realm.properties')
        end

        it { is_expected.to contain_file('/etc/rundeck/realm.properties') }
        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
        end

        it { is_expected.to contain_file('/etc/rundeck/log4j.properties') }
        it 'generates valid content for log4j.propertiess' do
          content = catalogue.resource('file', '/etc/rundeck/log4j.properties')[:content]
          expect(content).to include('log4j.appender.server-logger.file=/var/log/rundeck/rundeck.log')
        end

        it { is_expected.not_to contain_file('/etc/rundeck/profile') }
        it { is_expected.to contain_file(overrides) }

        it 'generates valid content for the profile overrides file' do
          content = catalogue.resource('file', overrides)[:content]
          expect(content).to include('RDECK_BASE=/var/lib/rundeck')
          expect(content).to include('RDECK_CONFIG=/etc/rundeck')
          expect(content).to include('RDECK_INSTALL=/var/lib/rundeck')
          expect(content).to include('JAAS_CONF=$RDECK_CONFIG/jaas-auth.conf')
          expect(content).to include('LOGIN_MODULE=authentication')
          expect(content).to include('RDECK_JVM_SETTINGS="-Xmx1024m -Xms256m -server"')
        end

        it { is_expected.to contain_rundeck__config__aclpolicyfile('admin') }
        it { is_expected.to contain_rundeck__config__aclpolicyfile('apitoken') }
      end

      describe 'rundeck::config with rdeck_profile_template set' do
        template = 'rundeck/../spec/fixtures/files/profile.template'
        let(:params) { { rdeck_profile_template: template } }

        it { is_expected.to contain_file('/etc/rundeck/profile') }
      end

      describe 'rundeck::config with rdeck_override_template set' do
        template = 'rundeck/../spec/fixtures/files/override.template'
        let(:params) { { rdeck_override_template: template } }

        it { is_expected.to contain_file(overrides) }
        it 'uses the content for the profile overrides template' do
          content = catalogue.resource('file', overrides)[:content]
          expect(content).to include('test override template')
        end
      end

      describe 'rundeck::config with jvm_args set' do
        jvm_args = '-Dserver.http.port=8008 -Xms2048m -Xmx2048m -server'
        let(:params) { { jvm_args: jvm_args } }

        it { is_expected.to contain_file(overrides) }
        it 'generates valid content for the profile overrides file' do
          content = catalogue.resource('file', overrides)[:content]
          expect(content).to include("RDECK_JVM_SETTINGS=\"#{jvm_args}\"")
        end
      end

      describe 'rundeck::config with manage_home=false with external homedir file resource' do
        let(:pre_condition) { 'File{"/var/lib/rundeck": ensure => directory }' }
        let(:params) { { manage_home: false } }

        it { is_expected.to contain_file('/var/lib/rundeck').that_comes_before('File[/var/lib/rundeck/.ssh/id_rsa]') }
      end

      describe 'rundeck::config with manage_home=false but no external homedir file resource' do
        let(:params) { { manage_home: false } }

        it { is_expected.to raise_error(Puppet::PreformattedError, %r{when rundeck::manage_home = false a file definition for the home directory must be included outside of this module.}) }
      end
    end
  end
end
