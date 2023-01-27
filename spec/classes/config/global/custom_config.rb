# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          custom_config: {
            'grails.plugin.databasemigration.updateOnStart' => true,
            'rundeck.config.storage.converter.1.type' => 'jasypt-encryption',
            'rundeck.config.storage.converter.1.path' => 'projects',
            'rundeck.config.storage.converter.1.config.password' => 'default.encryption.password',
            'rundeck.config.storage.converter.1.config.encryptorType' => 'custom',
            'rundeck.config.storage.converter.1.config.algorithm' => 'PBEWITHSHA256AND128BITAES-CBC-BC',
            'rundeck.config.storage.converter.1.config.provider' => 'BC'
          }
        }
      end

      # content and meta data for passwords
      it 'generates custom_config content for rundeck-config.groovy' do
        is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').
          with_content(%r{grails\.plugin.databasemigration.updateOnStart=true}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.type=jasypt-encryption}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.path=projects}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.config\.password=default.encryption.password}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.config\.encryptorType=custom}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.config\.algorithm=PBEWITHSHA256AND128BITAES-CBC-BC}).
          with_content(%r{rundeck\.config\.storage.converter\.1\.config\.provider=BC})
      end
    end
  end
end
