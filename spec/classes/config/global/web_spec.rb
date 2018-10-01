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

  context 'rundeck version prior 3.x with empty params' do
    let(:params) { { package_ensure: '2.11.5' } }

    it 'generates augeas resource with default security_role' do
      is_expected.to contain_augeas('rundeck/web.xml/security-role/role-name'). \
        with_changes(["set web-app/security-role/role-name/#text 'user'"])
    end
  end

  context 'rundeck version prior 3.x with security_role param' do
    let(:params) { { package_ensure: '2.11.5', security_role: 'superduper' } }

    it 'generates augeas resource with specified security_role' do
      is_expected.to contain_augeas('rundeck/web.xml/security-role/role-name'). \
        with_changes(["set web-app/security-role/role-name/#text 'superduper'"])
    end
  end

  context 'rundeck version prior 3.x with session_timeout param' do
    let(:params) { { package_ensure: '2.11.5', session_timeout: 60 } }

    it 'generates augeas resource with specified session_timeout' do
      is_expected.to contain_augeas('rundeck/web.xml/session-config/session-timeout'). \
        with_changes(["set web-app/session-config/session-timeout/#text '60'"])
    end
  end
end
