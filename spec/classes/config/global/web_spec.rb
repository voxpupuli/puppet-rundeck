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

  context 'with security_role array' do
    security_role = %w(DevOps roots)
    let(:params) { { security_role: 'security_role' } }

    security_role.each do |role|
      it 'generates augeas resource with specified security_roles' do
        should contain_augeas('rundeck/web.xml/security-role/role-name') .with_changes(["set web-app/security-role/#text[last()] '\t\t'", "set web-app/security-role/role-name[last()+1]/#text '#{role}'", "set web-app/security-role/#text[last()+1] '\t'"])
      end
    end
  end

  context 'with session_timeout param' do
    let(:params) { { session_timeout: '60' } }

    it 'generates augeas resource with specified session_timeout' do
      should contain_augeas('rundeck/web.xml/session-config/session-timeout') .with_changes(["set web-app/session-config/session-timeout/#text '60'"])
    end
  end
end
