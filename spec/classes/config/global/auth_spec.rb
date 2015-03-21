require 'spec_helper'

describe 'rundeck' do
  let(:facts) {{
    :osfamily        => 'Debian',
    :fqdn            => 'test.domain.com',
    :serialnumber    => 0,
    :rundeck_version => ''
  }}

  describe 'with empty params' do
    let(:params) {{
    }}

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      content.should include('admin:admin,user,admin,architect,deploy,build')
    end
  end

  describe 'with empty auth users array' do
    let(:params) {{
      :auth_config => {
        'file' => {
          'auth_users' => []
        }
      }
    }}

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      content.should include('admin:admin,user,admin,architect,deploy,build')
    end
  end

  describe 'with auth users array' do
    let(:params) {{
      :auth_config => {
        'file' => {
          'auth_users' => [
            {
              'username' => 'testuser',
              'password' => 'password',
              'roles'    => ['user', 'deploy']
            },
            {
              'username' => 'anotheruser',
              'password' => 'anotherpassword',
              'roles'    => ['user']
            }
          ]
        }
      }
    }}

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      content.should include('admin:admin,user,admin,architect,deploy,build')
      content.should include('testuser:password,user,deploy')
      content.should include('anotheruser:anotherpassword,user')
    end
  end

  describe 'with auth user without roles' do
    let(:params) {{
      :auth_config => {
        'file' => {
          'auth_users' => [
            {
              'username' => 'testuser',
              'password' => 'password'
            }
          ]
        }
      }
    }}

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      content.should include('admin:admin,user,admin,architect,deploy,build')
      content.should include('testuser:password')
    end
  end

  describe 'backward compatibility (no array of users)' do
    let(:params) {{
      :auth_config => {
        'file' => {
          'auth_users' => {
              'username' => 'testuser',
              'password' => 'password',
              'roles'    => ['user', 'deploy']
          }
        }
      }
    }}

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      content.should include('admin:admin,user,admin,architect,deploy,build')
      content.should include('testuser:password,user,deploy')
    end
  end
end
