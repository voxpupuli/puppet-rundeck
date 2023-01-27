# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} (properties file)" do
      let :facts do
        facts
      end

      describe "rundeck::config::global::rundeck_config class with use hmac request tokens parameter on #{os} (properties file)" do
        value = true
        security_hash = {
          'useHMacRequestTokens' => value
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.useHMacRequestTokens=#{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with use api cookie access parameter on #{os} (properties file)" do
        value = true
        security_hash = {
          'apiCookieAccess' => value
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.apiCookieAccess\.enabled=#{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with api tokens duration parameter on #{os} (properties file)" do
        duration = '0'
        security_hash = {
          'apiTokensDuration' => duration
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.api\.tokens\.duration\.max=#{duration}}) }
      end

      describe "rundeck::config::global::rundeck_config class with csrf referrer filter method parameter on #{os} (properties file)" do
        value = 'NONE'
        security_hash = {
          'csrfRefererFilterMethod' => value
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.csrf\.referer\.filterMethod=#{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with csrf referrer require https parameter on #{os} (properties file)" do
        value = true
        security_hash = {
          'csrfRefererRequireHttps' => value
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.csrf\.referer\.requireHttps=#{value}}) }
      end

      describe "rundeck::config::global::rundeck_config class with no security parameters on #{os} (properties file)" do
        bool_value = true
        filter_method_parameter = 'NONE'
        duration = '0'
        security_hash = {}
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', security_config: security_hash } }

        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.useHMacRequestTokens=#{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.apiCookieAccess\.enabled=#{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.api\.tokens\.duration\.max=#{duration}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.csrf\.referer\.filterMethod=#{filter_method_parameter}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.csrf\.referer\.allowApi=#{bool_value}}) }
        it { is_expected.not_to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.security\.csrf\.referer\.requireHttps=#{bool_value}}) }
      end

      describe "rundeck::config::global::rundeck_config class without any parameters on #{os} (properties file)" do
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp' } }

        it {
          is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').
            with_content(%r{loglevel\.default=INFO}).
            with_content(%r{rdeck\.base=/var/lib/rundeck}).
            with_content(%r{log4j\.configurationFile=/etc/rundeck/log4j2.properties}).
            with_content(%r{rundeck\.security\.useHMacRequestTokens=true}).
            with_content(%r{dataSource\.dbCreate=update}).
            with_content(%r{dataSource\.url=jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true}).
            with_content(%r{grails\.serverURL=http://foo.example.com:4440}).
            with_content(%r{rundeck\.clusterMode\.enabled=false}).
            with_content(%r{rundeck\.projectsStorageType=filesystem}).
            with_content(%r{quartz\.threadPool\.threadCount=10}).
            with_content(%r{rundeck\.storage\.provider\.1\.type=file})
        }
      end

      describe "rundeck::config::global::rundeck_config class with execution mode parameter 'active' on #{os} (properties file)" do
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', execution_mode: 'active' } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.executionMode=active}) }
      end

      describe "rundeck::config::global::rundeck_config class with execution mode parameter 'passive' on #{os} (properties file)" do
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', execution_mode: 'passive' } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.executionMode=passive}) }
      end

      describe "rundeck::config::global::rundeck_config class with key storage encryption on #{os} (properties file)" do
        storage_encrypt_config_hash = {
          'type' => 'thetype',
          'path' => '/storagepath',
          'config.encryptionType' => 'basic',
          'config.password' => 'verysecure'
        }
        let(:params) { { rdeck_config_template_type: 'epp', rdeck_config_type: 'properties', rdeck_config_template: 'rundeck/rundeck-config.properties.epp', storage_encrypt_config: storage_encrypt_config_hash } }

        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.storage\.converter\.1\.type=thetype}) }
        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.storage\.converter\.1\.path=/storagepath}) }
        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.storage\.converter\.1\.config\.encryptionType=basic}) }
        it { is_expected.to contain_file('/etc/rundeck/rundeck-config.properties').with_content(%r{rundeck\.storage\.converter\.1\.config\.password=verysecure}) }
      end
    end
  end
end
