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

  context 'rundeck with empty params' do
    let(:params) { { package_ensure: 'latest' } }

    it 'generates augeas resource with default security_role' do
      is_expected.to contain_augeas('rundeck/web.xml/security-role/role-name'). \
        with_changes(["set web-app/security-role/role-name/#text 'user'"])
    end
  end

  context 'rundeck with security_role param' do
    let(:params) { { package_ensure: 'latest', security_role: 'superduper' } }

    it 'generates augeas resource with specified security_role' do
      is_expected.to contain_augeas('rundeck/web.xml/security-role/role-name'). \
        with_changes(["set web-app/security-role/role-name/#text 'superduper'"])
    end
  end

  context 'rundeck with session_timeout param' do
    let(:params) { { package_ensure: 'latest', session_timeout: 60 } }

    it 'generates augeas resource with specified session_timeout' do
      is_expected.to contain_augeas('rundeck/web.xml/session-config/session-timeout'). \
        with_changes(["set web-app/session-config/session-timeout/#text '60'"])
    end
  end
end
