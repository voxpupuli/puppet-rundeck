require 'spec_helper'

describe 'rundeck::config::securityroles', type: :define do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          serialnumber: 0,
          rundeck_version: ''
        )
      end

      describe 'with array parameters' do
        let(:title) { 'source one' }
        let(:params) do
          {
            'package_ensure'               => 'latest',
            'security_roles_array_enabled' => true
          }
        end

        security_roles_array = %w[devops roots]

        security_roles_array.each do |roles|
          it "augeas with param: #{roles}" do
            contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text '#{roles}'"])
          end
        end
      end
    end
  end
end
