# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      overrides = '/etc/default/rundeckd'
      overrides = '/etc/sysconfig/rundeckd' if %w[RedHat].include? facts[:os]['family']

      let :facts do
        facts
      end

      context 'with default parameters test rundeck::config' do
        it { is_expected.to contain_file('/var/lib/rundeck').with(ensure: 'directory') }
        it { is_expected.to contain_file('/var/lib/rundeck/libext').with(ensure: 'directory') }
        it { is_expected.to contain_file('/etc/rundeck').with(ensure: 'directory') }
        it { is_expected.to contain_file('/var/lib/rundeck/var').with(ensure: 'directory') }
        it { is_expected.to contain_file('/var/lib/rundeck/var/tmp').with(ensure: 'directory') }
        it { is_expected.to contain_file('/var/lib/rundeck/logs').with(ensure: 'directory') }

        it { is_expected.to contain_file('/var/log/rundeck').with(ensure: 'directory') }

        it { is_expected.to contain_file('/etc/rundeck/log4j2.properties') }

        it 'generates valid content for log4j2.propertiess' do
          content = catalogue.resource('file', '/etc/rundeck/log4j2.properties')[:content]
          expect(content).to include('property.baseDir = /var/log/rundeck')
        end

        it { is_expected.to contain_rundeck__config__aclpolicyfile('admin') }
        it { is_expected.to contain_file('/etc/rundeck/admin.aclpolicy') }
        it { is_expected.to contain_rundeck__config__aclpolicyfile('apitoken') }
        it { is_expected.to contain_file('/etc/rundeck/apitoken.aclpolicy') }

        it { is_expected.to contain_file(overrides) }

        it 'generates valid content for the profile overrides file' do
          content = catalogue.resource('file', overrides)[:content]
          expect(content).to include('RDECK_BASE="/var/lib/rundeck"')
          expect(content).to include('RDECK_CONFIG="/etc/rundeck"')
          expect(content).to include('RDECK_CONFIG_FILE="$RDECK_CONFIG/rundeck-config.properties"')
          expect(content).to include('RDECK_INSTALL="$RDECK_BASE"')
          expect(content).to include('LOGIN_MODULE=authentication')
          expect(content).to include('RDECK_JVM_SETTINGS="-Xmx1024m -Xms256m -server"')
          expect(content).to include('RDECK_HTTP_PORT=4440')
        end

        it { is_expected.to contain_class('rundeck::config::jaas_auth') }
        it { is_expected.to contain_class('rundeck::config::framework') }

        it { is_expected.to contain_file('/etc/rundeck/project.properties').with(ensure: 'absent') }
        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with(ensure: 'file') }

        it 'generates valid content for rundeck-config.properties' do
          content = catalogue.resource('file', '/etc/rundeck/rundeck-config.properties')[:content]
          expect(content).to include('loglevel.default = info')
          expect(content).to include('rdeck.base = /var/lib/rundeck')
          expect(content).to include('rss.enabled = false')
          expect(content).to include('rundeck.clusterMode.enabled = false')
          expect(content).to include('rundeck.executionMode = active')
          expect(content).to include('quartz.threadPool.threadCount = 10')
          expect(content).to include('dataSource.url = jdbc:h2:file:/var/lib/rundeck/data/rundeckdb')
          expect(content).to include('rundeck.storage.provider.1.type = db')
          expect(content).to include('rundeck.storage.provider.1.path = keys')
        end
      end

      context 'with jvm_args set' do
        jvm_args = '-Dserver.http.port=8008 -Xms2048m -Xmx2048m -server'
        let(:params) { { jvm_args: jvm_args } }

        it { is_expected.to contain_file(overrides) }

        it 'generates valid content for the profile overrides file' do
          content = catalogue.resource('file', overrides)[:content]
          expect(content).to include("RDECK_JVM_SETTINGS=\"#{jvm_args}\"")
        end
      end
    end
  end
end
