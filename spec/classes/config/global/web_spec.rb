require 'spec_helper'

describe 'rundeck' do
  let(:facts) {{
    :osfamily        => 'RedHat',
    :fqdn            => 'test.example.com',
    :serialnumber    => 0,
    :rundeck_version => ''
  }}

  context 'with empty params' do
    it 'should generate augeas resource with default security_role' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') \
        .with_changes(["set web-app/security-role/role-name/#text 'user'"])
    end
  end

  context 'with security_role param' do
    let(:params) {{ :security_role => 'superduper' }}

    it 'should generate augeas resource with specified security_role' do
      should contain_augeas('rundeck/web.xml/security-role/role-name') \
        .with_changes(["set web-app/security-role/role-name/#text 'superduper'"])
    end
  end
end
