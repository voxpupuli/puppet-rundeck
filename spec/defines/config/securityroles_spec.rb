require 'spec_helper'

describe 'rundeck::config::global::securityroles', type: :define do
  let(:params) do
    {
      name: %w(DevOps roots)
    }
  end
  let(:title) { 'test' }
  it 'generates augeas resource with specified security_roles' do
     should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'DevOps'"])
     should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'roots'"])
  end
end
