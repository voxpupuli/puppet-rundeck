require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: '3.8.1'
          }
        end

        it { should compile }
        it { should contain_class('rundeck::params') }
        it { should contain_class('rundeck::install').that_comes_before('Class[rundeck::config]') }
        it { should contain_class('rundeck::config') }
        it { should contain_class('rundeck::service').that_comes_before('Class[rundeck]') }
        it { should contain_class('rundeck').that_requires('Class[rundeck::service]') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'rundeck class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
          serialnumber: 0,
          rundeck_version: '',
          puppetversion: '3.8.1'
        }
      end

      it { expect { should contain_package('rundeck') }.to raise_error(Puppet::Error, %r{Nexenta not supported}) }
    end
  end

  context 'non-platform-specific config parameters' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        serialnumber: 0,
        rundeck_version: '',
        puppetversion: '3.8.1'
      }
    end

    # auth_config cannot be passed as a parameter to rundeck::config :-(
    # so we have to test it here
    describe 'setting auth_config ldap roleUsernameMemberAttribute' do
      let(:params) do
        {
          auth_types: ['ldap'],
          auth_config: {
            'ldap' => {
              'role_username_member_attribute' => 'memberUid'
            }
          }
        }
      end
      it { should contain_file('/etc/rundeck/jaas-auth.conf') }
      it 'generates valid content for jaas-auth.conf' do
        content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
        expect(content).to include('roleUsernameMemberAttribute="memberUid"')
        expect(content).not_to include('roleMemberAttribute')
      end
    end

    describe 'setting auth_config ldap url' do
      let(:params) do
        {
          auth_types: ['ldap'],
          auth_config: {
            'ldap'     => {
              'url'    => 'ldaps://myrealldap.example.com',
              'server' => 'fakeldap',
              'port'   => '983'
            }
          }
        }
      end
      it { should contain_file('/etc/rundeck/jaas-auth.conf') }
      it 'generates valid content for jaas-auth.conf' do
        content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
        expect(content).to include('providerUrl="ldaps://myrealldap.example.com"')
        expect(content).not_to include('providerUrl="ldap://fakeldap:983"')
      end
    end
  end
end
