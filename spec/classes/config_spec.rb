require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config class without any parameters on #{osfamily}" do
        let(:facts) do
          {
            :osfamily        => osfamily,
            :serialnumber    => 0,
            :rundeck_version => '',
            :puppetversion   => '3.8.1'
          }
        end

        it { should contain_class('rundeck::config::global::framework') }
        it { should contain_class('rundeck::config::global::project') }
        it { should contain_class('rundeck::config::global::rundeck_config') }

        it { should contain_file('/etc/rundeck').with('ensure' => 'directory') }

        it { should contain_file('/etc/rundeck/jaas-auth.conf') }
        it 'should generate valid content for jaas-auth.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(content).to include('PropertyFileLoginModule')
          expect(content).to include('/etc/rundeck/realm.properties')
        end

        it { should contain_file('/etc/rundeck/realm.properties') }
        it 'should generate valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
        end

        it { should contain_file('/etc/rundeck/log4j.properties') }
        it 'should generate valid content for log4j.propertiess' do
          content = catalogue.resource('file', '/etc/rundeck/log4j.properties')[:content]
          expect(content).to include('log4j.appender.server-logger.file=/var/log/rundeck/rundeck.log')
        end

        it { should contain_file('/etc/rundeck/profile') }
        it 'should generate valid content for profile' do
          content = catalogue.resource('file', '/etc/rundeck/profile')[:content]
          expect(content).to include('-Drdeck.base=/var/lib/rundeck')
          expect(content).to include('-Drundeck.server.configDir=/etc/rundeck')
          expect(content).to include('-Dserver.datastore.path=/var/lib/rundeck/data')
          expect(content).to include('-Drundeck.server.serverDir=/var/lib/rundeck')
          expect(content).to include('-Drdeck.projects=/var/lib/rundeck/projects')
          expect(content).to include('-Drdeck.runlogs=/var/lib/rundeck/logs')
          expect(content).to include('-Drundeck.config.location=/etc/rundeck/rundeck-config.groovy')
          expect(content).to include('-Djava.security.auth.login.config=/etc/rundeck/jaas-auth.conf')
          expect(content).to include('-Dloginmodule.name=authentication')
          expect(content).to include('RDECK_JVM="$RDECK_JVM -Xmx1024m -Xms256m -server"')
        end

        it { should contain_rundeck__config__aclpolicyfile('admin') }
        it { should contain_rundeck__config__aclpolicyfile('apitoken') }
      end
    end

    describe 'rundeck::config with jvm_args set' do
      jvm_args = '-Dserver.http.port=8008 -Xms2048m -Xmx2048m -server'
      let(:facts) do
        {
          :osfamily        => 'RedHat',
          :serialnumber    => 0,
          :rundeck_version => '',
          :puppetversion   => '3.8.1'
        }
      end
      let(:params) { { :jvm_args => jvm_args } }
      it { should contain_file('/etc/rundeck/profile') }
      it 'should generate valid content for profile' do
        content = catalogue.resource('file', '/etc/rundeck/profile')[:content]
        expect(content).to include("RDECK_JVM=\"$RDECK_JVM #{jvm_args}\"")
      end
    end
  end
end
