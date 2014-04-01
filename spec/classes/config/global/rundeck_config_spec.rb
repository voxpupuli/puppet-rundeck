require 'spec_helper'

describe 'rundeck::config::global::rundeck_config' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "rundeck::config::global::rundeck_config class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
            :osfamily => osfamily,
        }}

        config_details = {
          'loglevel.default' => 'INFO',
          'rss.enabled' => 'false',
          'grails.serverURL' => 'http://localhost:4440',
          'dataSource.dbCreate' => 'update',
          'dataSource.url' => 'jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true'
        }

        config_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/etc/rundeck/rundeck-config.properties',
            'setting' => key,
            'value'   => value
          ) }
        end

        it { should contain_ini_setting('config rdeck.base').with(
          'path'    => '/etc/rundeck/rundeck-config.properties',
          'setting' => 'rdeck.base',
          'value'   => '/var/lib/rundeck'
        ) }

      end
    end
  end
end