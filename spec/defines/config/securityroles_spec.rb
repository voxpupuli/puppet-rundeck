require 'spec_helper'

describe 'rundeck::config::securityroles', type: :define do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::securityroles definition with array parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'security_roles_array_enabled' => true
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

        security_roles_array = %w(devops roots)

        security_roles_array.each do |roles|
          it "augeas with param: #{roles}" do
            contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text '#{roles}'"])
          end
        end
      end
    end
  end
end
