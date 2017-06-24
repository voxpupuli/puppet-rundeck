require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w[Debian RedHat].each do |osfamily|
      let(:params) do
        {
          ssl_enabled: true
        }
      end
      let(:facts) do
        {
          osfamily: osfamily,
          serialnumber: 0,
          rundeck_version: '',
          puppetversion: Puppet.version
        }
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
