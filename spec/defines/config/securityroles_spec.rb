require 'spec_helper'

describe 'rundeck::config::global::securityroles', type: :define do
  let(:facts) do
    {
      osfamily: 'RedHat',
      fqdn: 'test.example.com',
      serialnumber: 0,
      rundeck_version: ''
    }
  end
  describe "rundeck::config::global::securityroles definition with array on #{osfamily}" do
    let(:title) { 'test' }
    let(:params) do
      { name: %w(DevOps roots) }
    end

    it 'generates augeas resource with specified security_roles' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'DevOps'"])
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'roots'"])
    end
  end
end
