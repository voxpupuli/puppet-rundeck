require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) do
        {
          ssl_enabled: true
        }
      end
      let(:facts) do
        os_facts
      end

      ssl_details = {
        'keystore' => '/etc/rundeck/ssl/keystore',
        'keystore.password' => 'adminadmin',
        'key.password' => 'adminadmin',
        'truststore' => '/etc/rundeck/ssl/truststore',
        'truststore.password' => 'adminadmin'
      }

      it { is_expected.to contain_file('/etc/rundeck/ssl').with('ensure' => 'directory') }
      it { is_expected.to contain_file('/etc/rundeck/ssl/ssl.properties') }

      ssl_details.each do |key, value|
        it do
          is_expected.to contain_ini_setting(key).with(
            'path' => '/etc/rundeck/ssl/ssl.properties',
            'setting' => key,
            'value'   => value
          )
        end
      end
    end
  end
end
