require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with storage_convert set' do
        storage_converter_hash = {
          'rundeck.storage.converter."1".type'                 => 'jasypt-encryption',
          'rundeck.storage.converter."1".path'                 => 'keys',
          'rundeck.storage.converter."1".config.encryptorType' => 'basic',
          'rundeck.storage.converter."1".config.password'      => 'sekrit',
          'rundeck.storage.converter."1".config.provider'      => 'BC'
        }

        let(:params) do
          {
            storage_converter: storage_converter_hash
          }
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'generates storage_converter content for rundeck-config.groovy' do
          content = catalogue.resource('file', '/etc/rundeck/rundeck-config.groovy')[:content]
          expect(content).to include('rundeck.storage.converter."1".type = "jasypt-encryption"')
          expect(content).to include('rundeck.storage.converter."1".path = "keys"')
          expect(content).to include('rundeck.storage.converter."1".config.encryptorType = "basic"')
          expect(content).to include('rundeck.storage.converter."1".config.password = "sekrit"')
          expect(content).to include('rundeck.storage.converter."1".config.provider = "BC"')
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end
end
