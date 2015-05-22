require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config class without any parameters on #{osfamily}" do
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        it { should contain_class('rundeck::config::global::framework') }
        it { should contain_class('rundeck::config::global::project') }
        it { should contain_class('rundeck::config::global::rundeck_config') }
        it { should contain_class('rundeck::config::global::ssl') }

        it { should contain_file('/etc/rundeck').with({'ensure' => 'directory'})}

        it { should contain_file('/etc/rundeck/jaas-auth.conf') }
        it 'should generate valid content for jaas-auth.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          content.should include('PropertyFileLoginModule')
          content.should include('/etc/rundeck/realm.properties')
        end

        it { should contain_file('/etc/rundeck/realm.properties') }
        it 'should generate valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          content.should include('admin:admin,user,admin,architect,deploy,build')
        end

        it { should contain_file('/etc/rundeck/log4j.properties') }
        it 'should generate valid content for log4j.propertiess' do
          content = catalogue.resource('file', '/etc/rundeck/log4j.properties')[:content]
          content.should include('log4j.appender.server-logger.file=/var/log/rundeck/rundeck.log')
        end

        it { should contain_file('/etc/rundeck/profile') }
        it 'should generate valid content for profile' do
          content = catalogue.resource('file', '/etc/rundeck/profile')[:content]
          content.should include('-Drdeck.base=/var/lib/rundeck')
          content.should include('-Drundeck.server.configDir=/etc/rundeck')
          content.should include('-Dserver.datastore.path=/var/lib/rundeck/data')
          content.should include('-Drundeck.server.serverDir=/var/lib/rundeck')
          content.should include('-Drdeck.projects=/var/rundeck/projects')
          content.should include('-Drdeck.runlogs=/var/lib/rundeck/logs')
          content.should include('-Drundeck.config.location=/etc/rundeck/rundeck-config.groovy')
          content.should include('-Djava.security.auth.login.config=/etc/rundeck/jaas-auth.conf')
          content.should include('-Dloginmodule.name=authentication')
          content.should include('RDECK_JVM="$RDECK_JVM -Xmx1024m -Xms256m -server"')
        end


        it { should contain_rundeck__config__aclpolicyfile('admin') }
        it { should contain_rundeck__config__aclpolicyfile('apitoken') }

      end
    end

    describe 'rundeck::config with jvm_args set' do
      jvm_args = '-Dserver.http.port=8008 -Xms2048m -Xmx2048m -server'
      let(:facts) {{
        :osfamily        => 'RedHat',
        :serialnumber    => 0,
        :rundeck_version => ''
      }}
      let(:params) {{ :jvm_args => jvm_args }}
      it { should contain_file('/etc/rundeck/profile') }
      it 'should generate valid content for profile' do
        content = catalogue.resource('file', '/etc/rundeck/profile')[:content]
        content.should include("RDECK_JVM=\"$RDECK_JVM #{jvm_args}\"")
      end
    end
  end
end
