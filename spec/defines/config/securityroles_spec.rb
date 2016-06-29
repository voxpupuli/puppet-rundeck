require 'spec_helper'

describe 'rundeck::config::global::securityroles', type: :define do
test_roles = %w(DevOps roots)
let(:title) { name }

  context 'test security roles with define' do
    let(:params) do
      {
        rundeck_config_global_web_sec_roles: test_roles
      }
    end

    it 'generates augeas resource with specified security_roles' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'DevOps'"])
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'roots'"])
    end
  end
end



