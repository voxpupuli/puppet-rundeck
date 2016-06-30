require 'spec_helper'

describe 'rundeck::config::global::securityroles', type: :define do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::securityroles definition with array parameters on #{osfamily}" do
        let(:title) { 'test' }
        let(:params) do
          {
            name: %w(DevOps roots)
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


        let(:title) { 'test' }
        it 'generates augeas resource with specified security_roles' do
           should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'DevOps'"])
           should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'roots'"])
        end
      end
    end
  end
end
