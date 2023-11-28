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

        it 'generates valid content for ssl.properties' do
          content = catalogue.resource('file', '/etc/rundeck/ssl/ssl.properties')[:content]
          expect(content).to include('key.password=verysecure')
        end
      end
    end
  end
end
