require 'spec_helper'

describe 'rundeck' do
  let(:facts) do
    {
      :osfamily        => 'Debian',
      :fqdn            => 'test.domain.com',
      :serialnumber    => 0,
      :rundeck_version => '',
      :puppetversion   => Puppet.version,
    }
  end

  describe 'with empty params' do
    let(:params) do
      {
      }
    end

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      expect(content).to include('admin:admin,user,admin,architect,deploy,build')
    end
  end

  describe 'with empty auth users array' do
    let(:params) do
      {
        :auth_config => {
          'file' => {
            'auth_users' => [],
          },
        }
      }
    end

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      expect(content).to include('admin:admin,user,admin,architect,deploy,build')
    end
  end

  describe 'with auth users array' do
    let(:params) do
      {
        :auth_config => {
          'file' => {
            'auth_users' => [
              {
                'username' => 'testuser',
                'password' => 'password',
                'roles'    => %w(user deploy),
              },
              {
                'username' => 'anotheruser',
                'password' => 'anotherpassword',
                'roles'    => ['user'],
              },
            ],
          },
        },
      }
    end

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      expect(content).to include('admin:admin,user,admin,architect,deploy,build')
      expect(content).to include('testuser:password,user,deploy')
      expect(content).to include('anotheruser:anotherpassword,user')
    end
  end

  describe 'with auth user without roles' do
    let(:params) do
      {
        :auth_config => {
          'file' => {
            'auth_users' => [
              {
                'username' => 'testuser',
                'password' => 'password',
              },
            ],
          },
        },
      }
    end

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      expect(content).to include('admin:admin,user,admin,architect,deploy,build')
      expect(content).to include('testuser:password')
    end
  end

  describe 'backward compatibility (no array of users)' do
    let(:params) do
      {
        :auth_config => {
          'file' => {
            'auth_users' => {
              'username' => 'testuser',
              'password' => 'password',
              'roles'    => %w(user deploy),
            },
          },
        },
      }
    end

    it 'should generate valid content for realm.properties' do
      content = catalogue.resource('file', '/etc/rundeck/realm.properties')[:content]
      expect(content).to include('admin:admin,user,admin,architect,deploy,build')
      expect(content).to include('testuser:password,user,deploy')
    end
  end
end
