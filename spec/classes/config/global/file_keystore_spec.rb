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
  describe 'add file-based key storage' do
    let(:params) do
      {
        :file_keystorage_dir  => '/var/lib/rundeck/var/storage',
        :file_keystorage_keys => {
          'password_key' => {
            'value'        => 'gobbledygook',
            'path'         => 'foo/bar',
            'data_type'    => 'password',
            'content_type' => 'application/x-rundeck-data-password',
          },
          'public_key' => {
            'value'        => 'ssh-rsa AAAAB3rhwL1EoAIuI3hw9wZL146zjPZ6FIqgZKvO24fpZENYnNfmHn5AuOGBXYGTjeVPMzwV7o0mt3iRWk8J9Ujqvzp45IHfEAE7SO2frEIbfALdcwcNggSReQa0du4nd user@localhost',
            'path'         => 'foo/bar',
            'data_type'    => 'public',
            'content_type' => 'application/pgp-keys',
          },
        },
      }
    end

    it { should contain_file('/var/lib/rundeck/var/storage/content/keys/foo/bar/password_key.password') }
    it 'should generate valid content for password_key' do
      content = catalogue.resource('file', '/var/lib/rundeck/var/storage/content/keys/foo/bar/password_key.password')[:content]
      expect(content).to include('gobbledygook')
    end
    it { should contain_file('/var/lib/rundeck/var/storage/meta/keys/foo/bar/public_key.public') }
    it 'should generate valid meta for password_key' do
      content = catalogue.resource('file', '/var/lib/rundeck/var/storage/meta/keys/foo/bar/password_key.password')[:content]
      expect(content).to include('application/x-rundeck-data-password')
    end

    it { should contain_file('/var/lib/rundeck/var/storage/content/keys/foo/bar/public_key.public') }
    it 'should generate valid content for public_key' do
      content = catalogue.resource('file', '/var/lib/rundeck/var/storage/content/keys/foo/bar/public_key.public')[:content]
      expect(content).to include('ssh-rsa AAAAB3rhwL1EoAIuI3hw9wZL146zjPZ6FIqgZKvO24fpZENYnNfmHn5AuOGBXYGTjeVPMzwV7o0mt3iRWk8J9Ujqvzp45IHfEAE7SO2frEIbfALdcwcNggSReQa0du4nd user@localhost')
    end
    it { should contain_file('/var/lib/rundeck/var/storage/meta/keys/foo/bar/public_key.public') }
    it 'should generate valid meta for public_key' do
      content = catalogue.resource('file', '/var/lib/rundeck/var/storage/meta/keys/foo/bar/public_key.public')[:content]
      expect(content).to include('application/pgp-keys')
    end
  end
end
