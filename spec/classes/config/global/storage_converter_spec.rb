# rubocop:disable RSpec/MultipleExpectations

require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w[Debian RedHat].each do |osfamily|
      storage_converter_hash = {
        'rundeck.storage.converter."1".type'                 => 'jasypt-encryption',
        'rundeck.storage.converter."1".path'                 => 'keys',
        'rundeck.storage.converter."1".config.encryptorType' => 'basic',
        'rundeck.storage.converter."1".config.password'      => 'sekrit',
        'rundeck.storage.converter."1".config.provider'      => 'BC'
      }

      let(:facts) do
        {
          osfamily: osfamily,
          fqdn: 'test.domain.com',
          serialnumber: 0,
          rundeck_version: '',
          puppetversion: Puppet.version
        }
      end

      let(:params) do
        {
          storage_converter: storage_converter_hash
        }
      end

      # content and meta data for passwords
      it 'generates storage_converter content for rundeck-config.groovy' do
        content = catalogue.resource('file', '/etc/rundeck/rundeck-config.groovy')[:content]
        expect(content).to include('rundeck.storage.converter."1".config.encryptorType = "basic"')
        expect(content).to include('rundeck.storage.converter."1".config.password = "sekrit"')
        expect(content).to include('rundeck.storage.converter."1".config.provider = "BC"')
        expect(content).to include('rundeck.storage.converter."1".path = "keys"')
        expect(content).to include('rundeck.storage.converter."1".type = "jasypt-encryption"')
      end
    end
  end
end
