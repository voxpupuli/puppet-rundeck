require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck::config::global::rundeck_config class with use hmac request tokens parameter on #{os}" do
        value = true
        security_hash = {
          'useHMacRequestTokens' => value
        }
        let(:params) { { security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.useHMacRequestTokens = #{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with use api cookie access parameter on #{os}" do
        value = true
        security_hash = {
          'apiCookieAccess' => value
        }
        let(:params) { { security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.apiCookieAccess\.enabled = #{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with api tokens duration parameter on #{os}" do
        duration = '0'
        security_hash = {
          'apiTokensDuration' => duration
        }
        let(:params) { { security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.api\.tokens\.duration\.max = #{duration}}) }
      end

      describe "rundeck::config::global::rundeck_config class with csrf referrer filter method parameter on #{os}" do
        value = 'NONE'
        security_hash = {
          'csrfRefererFilterMethod' => value
        }
        let(:params) { { security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.csrf\.referer\.filterMethod = #{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with csrf referrer require https parameter on #{os}" do
        value = true
        security_hash = {
          'csrfRefererRequireHttps' => value
        }
        let(:params) { { security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.csrf\.referer\.requireHttps = #{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with no security parameters on #{os}" do
        bool_value = true
        filter_method_parameter = 'NONE'
        duration = '0'
        security_hash = {}
        let(:params) { { security_config: security_hash } }

        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.useHMacRequestTokens = #{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.apiCookieAccess\.enabled = #{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.api\.tokens\.duration\.max = #{duration}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.csrf\.referer\.filterMethod = #{filter_method_parameter}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.csrf\.referer\.allowApi = #{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.security\.csrf\.referer\.requireHttps = #{bool_value}}) }
      end

      describe "rundeck::config::global::rundeck_config class without any parameters on #{os}" do
        let(:params) { {} }

        default_config = <<-CONFIG.gsub(%r{[^\S\n]{10}}, '')
          loglevel.default = "INFO"
          rdeck.base = "/var/lib/rundeck"
          rss.enabled = "false"
          rundeck.log4j.config.file = "/etc/rundeck/log4j.properties"

          rundeck.security.useHMacRequestTokens = true
          rundeck.security.apiCookieAccess.enabled = true

          dataSource {
            dbCreate = "update"
            url = "jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true"
          }

          grails.serverURL = "http://foo.example.com:4440"
          rundeck.clusterMode.enabled = "false"

          rundeck.projectsStorageType = "filesystem"
          quartz.props.threadPool.threadCount = "10"

          rundeck.storage.provider."1".type = "file"
          rundeck.storage.provider."1".config.baseDir = "/var/lib/rundeck/var/storage"
          rundeck.storage.provider."1".path = "/"

          rundeck.security.authorization.preauthenticated.enabled = "false"
          rundeck.security.authorization.preauthenticated.attributeName = "REMOTE_USER_GROUPS"
          rundeck.security.authorization.preauthenticated.delimiter = ":"
          rundeck.security.authorization.preauthenticated.userNameHeader = "X-Forwarded-Uuid"
          rundeck.security.authorization.preauthenticated.userRolesHeader = "X-Forwarded-Roles"
          rundeck.security.authorization.preauthenticated.redirectLogout = "false"
          rundeck.security.authorization.preauthenticated.redirectUrl = "/oauth2/sign_in"

        CONFIG

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with('content' => default_config) }
      end

      describe "rundeck::config::global::rundeck_config class with execution mode parameter 'active' on #{os}" do
        let(:params) { { execution_mode: 'active' } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.executionMode = "active"}) }
      end

      describe "rundeck::config::global::rundeck_config class with execution mode parameter 'passive' on #{os}" do
        let(:params) { { execution_mode: 'passive' } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').with_content(%r{rundeck\.executionMode = "passive"}) }
      end
    end
  end
end
