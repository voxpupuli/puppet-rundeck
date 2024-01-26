# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with ssl_enabled => true' do
        let(:params) do
          {
            ssl_enabled: true
          }
        end

        ssl_details = {
          'keystore' => '/etc/rundeck/ssl/keystore',
          'keystore.password' => 'adminadmin',
          'truststore' => '/etc/rundeck/ssl/truststore',
          'truststore.password' => 'adminadmin'
        }

        it { is_expected.to contain_file('/etc/rundeck/ssl').with('ensure' => 'directory') }
        it { is_expected.to contain_file('/etc/rundeck/ssl/ssl.properties') }

        it do
          is_expected.to contain_java_ks('keystore').with(
            ensure: 'present',
            certificate: '/etc/rundeck/ssl/rundeck.crt',
            private_key: '/etc/rundeck/ssl/rundeck.key',
            trustcacerts: true,
            password: 'adminadmin',
            target: '/etc/rundeck/ssl/keystore'
          )
        end

        it do
          is_expected.to contain_java_ks('truststore').with(
            ensure: 'present',
            password: 'adminadmin',
            target: '/etc/rundeck/ssl/truststore'
          )
        end

        ssl_details.each do |key, value|
          it 'generates valid content for ssl.properties' do
            content = catalogue.resource('file', '/etc/rundeck/ssl/ssl.properties')[:content]
            expect(content).to include("#{key}=#{value}")
          end
        end
      end

      context 'with ssl_enabled => true and key_password => verysecure' do
        let(:params) do
          {
            ssl_enabled: true,
            key_password: 'verysecure'
          }
        end

        it do
          is_expected.to contain_java_ks('keystore').with(
            ensure: 'present',
            destkeypass: 'verysecure'
          )
        end

        it do
          is_expected.to contain_java_ks('truststore').with(
            ensure: 'present',
            destkeypass: 'verysecure'
          )
        end

        it 'generates valid content for ssl.properties' do
          content = catalogue.resource('file', '/etc/rundeck/ssl/ssl.properties')[:content]
          expect(content).to include('key.password=verysecure')
        end
      end
    end
  end
end
