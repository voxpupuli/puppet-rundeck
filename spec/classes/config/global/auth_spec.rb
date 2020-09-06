require 'spec_helper'

describe 'rundeck' do
  let(:login_module) { 'org.eclipse.jetty.jaas.spi.PropertyFileLoginModule sufficient' }

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe 'with empty params' do
        let(:params) do
          {
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(jaas_auth).to include(login_module)
        end
      end

      describe 'with empty auth users array' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_users' => []
              }
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(jaas_auth).to include(login_module)
        end
      end

      describe 'with auth users array' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_users' => [
                  {
                    'username' => 'testuser',
                    'password' => 'password',
                    'roles'    => %w[user deploy]
                  },
                  {
                    'username' => 'anotheruser',
                    'password' => 'anotherpassword',
                    'roles'    => ['user']
                  }
                ]
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

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(jaas_auth).to include(login_module)
        end
      end

      describe 'with multiauth ldap and file auth users array' do
        let(:params) do
          {
            auth_types: %w[ldap file],
            auth_config: {
              'file' => {
                'auth_users' => [
                  {
                    'username' => 'testuser',
                    'password' => 'password',
                    'roles'    => %w[user deploy]
                  },
                  {
                    'username' => 'anotheruser',
                    'password' => 'anotherpassword',
                    'roles'    => ['user']
                  }
                ]
              },

              'ldap' => {
                'debug'                   => 'true',
                'url'                     => 'localhost:389',
                'force_binding'           => 'true',
                'force_binding_use_root'  => 'true',
                'bind_dn'                 => 'test_rundeck',
                'bind_password'           => 'abc123',
                'user_base_dn'            => 'ou=users,ou=accounts,ou=corp,dc=xyz,dc=com',
                'user_rdn_attribute'      => 'sAMAccountName',
                'user_id_attribute'       => 'sAMAccountName',
                'user_password_attribute' => 'unicodePwd',
                'user_object_class'       => 'user',
                'role_base_dn'            => 'ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com',
                'role_name_attribute'     => 'cn',
                'role_member_attribute'   => 'member',
                'role_object_class'       => 'group',
                'supplemental_roles'      => 'user',
                'nested_groups'           => 'true'
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
      end

      describe 'with multiauth active_directory and file auth users array' do
        let(:params) do
          {
            auth_types: %w[active_directory file],
            auth_config: {
              'file' => {
                'auth_users' => [
                  {
                    'username' => 'testuser',
                    'password' => 'password',
                    'roles'    => %w[user deploy]
                  },
                  {
                    'username' => 'anotheruser',
                    'password' => 'anotherpassword',
                    'roles'    => ['user']
                  }
                ]
              },

              'active_directory' => {
                'debug'                   => 'true',
                'url'                     => 'localhost:389',
                'force_binding'           => 'true',
                'force_binding_use_root'  => 'true',
                'bind_dn'                 => 'test_rundeck',
                'bind_password'           => 'abc123',
                'user_base_dn'            => 'ou=users,ou=accounts,ou=corp,dc=xyz,dc=com',
                'user_rdn_attribute'      => 'sAMAccountName',
                'user_id_attribute'       => 'sAMAccountName',
                'user_password_attribute' => 'unicodePwd',
                'user_object_class'       => 'user',
                'role_base_dn'            => 'ou=role based,ou=security,ou=groups,ou=test,dc=xyz,dc=com',
                'role_name_attribute'     => 'cn',
                'role_member_attribute'   => 'member',
                'role_object_class'       => 'group',
                'supplemental_roles'      => 'user',
                'nested_groups'           => 'true'
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
      end

      describe 'with auth user without roles' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_users' => [
                  {
                    'username' => 'testuser',
                    'password' => 'password'
                  }
                ]
              }
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(jaas_auth).to include(login_module)
        end
      end

      describe 'backward compatibility (no array of users)' do
        let(:params) do
          {
            auth_config: {
              'file' => {
                'auth_users' => {
                  'username' => 'testuser',
                  'password' => 'password',
                  'roles'    => %w[user deploy]
                }
              }
            }
          }
        end

        it 'generates valid content for realm.properties' do
          content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
          expect(content).to include('admin:admin,user,admin,architect,deploy,build')
          expect(content).to include('testuser:password,user,deploy')
        end

        it 'contains PropertyFileLoginModule and be sufficient' do
          jaas_auth = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(jaas_auth).to include(login_module)
        end
      end

      describe 'ldap with rolePrefix' do
        let(:params) do
          {
            auth_types: %w[ldap],
            auth_config: {
              'ldap' => {
                'url'         => 'localhost:389',
                'role_prefix' => 'rundeck_'
              }
            }
          }
        end

        it 'generates valid content for jaas-auth.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(content).to include('rolePrefix="rundeck_"')
        end
      end

      describe 'active_directory with rolePrefix' do
        let(:params) do
          {
            auth_types: %w[active_directory],
            auth_config: {
              'active_directory' => {
                'url'         => 'localhost:389',
                'role_prefix' => 'rundeck_'
              }
            }
          }
        end

        it 'generates valid content for jaas-auth.conf' do
          content = catalogue.resource('file', '/etc/rundeck/jaas-auth.conf')[:content]
          expect(content).to include('rolePrefix="rundeck_"')
        end
      end
    end
  end
end
