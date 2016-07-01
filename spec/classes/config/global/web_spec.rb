require 'spec_helper'

describe 'rundeck' do
  let(:facts) do
    {
      osfamily: 'RedHat',
      fqdn: 'test.example.com',
      serialnumber: 0,
      rundeck_version: ''
    }
  end

  context 'with empty params' do
    it 'generates augeas resource with default security_role' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'user'"])
    end
  end

  context 'with security_role param' do
    let(:params) { { security_role: 'superduper' } }

    it 'generates augeas resource with specified security_role' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'superduper'"])
    end
  end

  context 'with session_timeout param' do
    let(:params) { { session_timeout: '60' } }

    it 'generates augeas resource with specified session_timeout' do
      should contain_augeas('rundeck/web.xml/session-config/session-timeout') .with_changes(["set web-app/session-config/session-timeout/#text '60'"])
    end
  end

  context "with security_role array" do
    let(:params) { { 'rundeck_config_global_web_sec_roles_true' => true, 'rundeck_config_global_web_sec_roles' => %w(DevOps roots) } }
    it 'generates augeas resource with specified security_role (with array)' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'DevOps'"])
      should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/role-name/#text 'roots'"])
    end
  end
end
