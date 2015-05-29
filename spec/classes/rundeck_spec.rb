require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        it { should contain_class('rundeck::params') }
        it { should contain_class('rundeck::install').that_comes_before('rundeck::config') }
        it { should contain_class('rundeck::config') }
        it { should contain_class('rundeck::service').that_comes_before('rundeck') }
        it { should contain_class('rundeck').that_requires('rundeck::service') }

        if osfamily.eql?('RedHat')
          it { should contain_package('java-1.7.0-openjdk') }
        else
          it { should contain_package('openjdk-7-jre') }
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'rundeck class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
        :serialnumber    => 0,
        :rundeck_version => ''
      }}

      it { expect { should contain_package('rundeck') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

  context 'non-platform-specific config parameters' do
    let(:facts) {{
      :osfamily        => 'RedHat',
      :serialnumber    => 0,
      :rundeck_version => ''
    }}

    # auth_config cannot be passed as a parameter to rundeck::config :-(
    # so we have to test it here
    describe 'setting auth_config ldap roleUsernameMemberAttribute' do
      let(:params) {{
        :auth_types => [ 'ldap' ],
        :auth_config => {
          'ldap' => {
            'role_username_member_attribute' => 'memberUid'
          }
        }
      }}
      it { should contain_file('/etc/rundeck/jaas-auth.conf') }
      it 'should generate valid content for jaas-auth.conf' do
        content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
        content.should include('roleUsernameMemberAttribute="memberUid"')
        content.should_not include('roleMemberAttribute')
      end
    end


  end
end
