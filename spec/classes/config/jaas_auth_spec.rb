# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with empty auth config test rundeck::config::jaas_auth' do
        let(:params) do
          {
            auth_config: {}
          }
        end

        it { is_expected.to contain_file('/etc/rundeck/realm.properties').with(ensure: 'absent') }
        it { is_expected.to contain_file('/etc/rundeck/jaas-loginmodule.conf').with(ensure: 'file') }

        it 'jaas-loginmodule.conf contains no auth classes' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(jaas_auth).not_to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule')
          expect(jaas_auth).not_to include('com.dtolabs.rundeck.jetty.jaas.JettyCombinedLdapLoginModule')
          expect(jaas_auth).not_to include('com.dtolabs.rundeck.jetty.jaas.JettyCachingLdapLoginModule')
          expect(jaas_auth).not_to include('org.rundeck.jaas.jetty.JettyPamLoginModule')
        end
      end

      context 'file auth with empty auth users array' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'jaas_config' => {
                  'file' => '/etc/rundeck/realm.properties',
                },
                'realm_config' => {
                  'admin_user'     => 'admin',
                  'admin_password' => 'admin',
                  'auth_users'     => [],
                },
              },
            }
          }
        end

        it { is_expected.to contain_file('/etc/rundeck/realm.properties').with(ensure: 'file') }
        it { is_expected.to contain_file('/etc/rundeck/jaas-loginmodule.conf').with(ensure: 'file') }

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
        end

        it 'contains PropertyFileLoginModule and default auth_flag' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(jaas_auth).to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required')
        end
      end

      context 'file auth with single auth user without roles' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'jaas_config' => {
                  'file' => '/etc/rundeck/realm.properties',
                },
                'realm_config' => {
                  'admin_user'     => 'admin',
                  'admin_password' => 'admin',
                  'auth_users'     => [
                    {
                      'username' => 'testuser',
                      'password' => 'password'
                    }
                  ]
                },
              },
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(jaas_auth).to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required')
        end
      end

      context 'file auth with single auth user and roles' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'jaas_config' => {
                  'file' => '/etc/rundeck/realm.properties',
                },
                'realm_config' => {
                  'admin_user'     => 'admin',
                  'admin_password' => 'admin',
                  'auth_users'     => [
                    {
                      'username' => 'testuser',
                      'password' => 'password',
                      'roles'    => %w[user deploy]
                    }
                  ]
                },
              },
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password,user,deploy')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(jaas_auth).to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required')
        end
      end

      context 'file auth with auth users array and auth_flag' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_flag'    => 'sufficient',
                'jaas_config'  => {
                  'file' => '/etc/rundeck/realm.properties',
                },
                'realm_config' => {
                  'admin_user'     => 'admin',
                  'admin_password' => 'admin',
                  'auth_users'     => [
                    {
                      'username' => 'testuser',
                      'password' => 'password',
                      'roles' => %w[user deploy]
                    },
                    {
                      'username' => 'anotheruser',
                      'password' => 'anotherpassword',
                      'roles' => ['user']
                    },
                  ],
                },
              },
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password,user,deploy')
          expect(content).to include('anotheruser:anotherpassword,user')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(jaas_auth).to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule sufficient')
        end
      end

      context 'with ldap auth using ldap_sync' do
        let(:params) do
          {
            auth_config: {
              'ldap' => {
                'jaas_config' => {
                  'debug' => 'true',
                  'providerUrl' => 'ldap://server:389',
                  'bindDn' => 'cn=Manager,dc=example,dc=com',
                  'bindPassword' => 'secret',
                  'authenticationMethod' => 'simple',
                  'forceBindingLogin' => 'false',
                  'userBaseDn' => 'ou=users,ou=accounts,ou=corp,dc=xyz,dc=com',
                  'userRdnAttribute' => 'sAMAccountName',
                  'userIdAttribute' => 'sAMAccountName',
                  'userPasswordAttribute' => 'unicodePwd',
                  'userObjectClass' => 'user',
                  'roleBaseDn' => 'ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com',
                  'roleNameAttribute' => 'cn',
                  'roleMemberAttribute' => 'member',
                  'roleObjectClass' => 'group'
                }
              }
            },
            security_config: {
              'syncLdapUser' => true
            }
          }
        end

        it 'generates valid content for rundeck-config.properties' do
          content = catalogue.resource('file', '/etc/rundeck/rundeck-config.properties')[:content]
          expect(content).to include('rundeck.security.syncLdapUser = true')
        end

        it 'generates valid content for jaas-loginmodule.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(content).to include(' com.dtolabs.rundeck.jetty.jaas.JettyCachingLdapLoginModule required')
          expect(content).to include('debug="true"')
          expect(content).to include('providerUrl="ldap://server:389"')
          expect(content).to include('bindDn="cn=Manager,dc=example,dc=com"')
          expect(content).to include('bindPassword="secret"')
          expect(content).to include('authenticationMethod="simple"')
          expect(content).to include('userBaseDn="ou=users,ou=accounts,ou=corp,dc=xyz,dc=com"')
          expect(content).to include('roleBaseDn="ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com"')
          expect(content).to include('roleObjectClass="group";')
        end
      end

      context 'with multiauth ldap and file with auth users array' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_flag'    => 'sufficient',
                'jaas_config'  => {
                  'file' => '/etc/rundeck/realm.properties',
                },
                'realm_config' => {
                  'admin_user'     => 'admin',
                  'admin_password' => 'admin',
                  'auth_users'     => [
                    {
                      'username' => 'testuser',
                      'password' => 'password',
                      'roles' => %w[user deploy]
                    },
                    {
                      'username' => 'anotheruser',
                      'password' => 'anotherpassword',
                      'roles' => ['user']
                    },
                  ],
                },
              },
              'ldap' => {
                'jaas_config' => {
                  'debug' => 'true',
                  'providerUrl' => 'ldap://server:389',
                  'bindDn' => 'cn=Manager,dc=example,dc=com',
                  'bindPassword' => 'secret',
                  'authenticationMethod' => 'simple',
                  'forceBindingLogin' => 'false',
                  'userBaseDn' => 'ou=users,ou=accounts,ou=corp,dc=xyz,dc=com',
                  'userRdnAttribute' => 'sAMAccountName',
                  'userIdAttribute' => 'sAMAccountName',
                  'userPasswordAttribute' => 'unicodePwd',
                  'userObjectClass' => 'user',
                  'roleBaseDn' => 'ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com',
                  'roleNameAttribute' => 'cn',
                  'roleMemberAttribute' => 'member',
                  'roleObjectClass' => 'group',
                  'nestedGroups' => 'true'
                },
              }
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password,user,deploy')
          expect(content).to include('anotheruser:anotherpassword,user')
        end

        it 'generates valid content for jaas-loginmodule.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-loginmodule.conf')[:content]
          expect(content).to include('org.eclipse.jetty.jaas.spi.PropertyFileLoginModule sufficient')
          expect(content).to include('file="/etc/rundeck/realm.properties";')
          expect(content).to include('com.dtolabs.rundeck.jetty.jaas.JettyCombinedLdapLoginModule required')
          expect(content).to include('debug="true"')
          expect(content).to include('providerUrl="ldap://server:389"')
          expect(content).to include('bindDn="cn=Manager,dc=example,dc=com"')
          expect(content).to include('bindPassword="secret"')
          expect(content).to include('authenticationMethod="simple"')
          expect(content).to include('userBaseDn="ou=users,ou=accounts,ou=corp,dc=xyz,dc=com"')
          expect(content).to include('roleBaseDn="ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com"')
          expect(content).to include('nestedGroups="true";')
        end
      end
    end
  end
end
