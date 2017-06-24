# rubocop:disable RSpec/MultipleExpectations

require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w[Debian RedHat].each do |osfamily|
      gui_config_hash = {
        'rundeck.gui.title'         => 'Test title',
        'rundeck.gui.brand.html'    => '<b>App</b>',
        'rundeck.gui.logo'          => 'test-logo.png',
        'rundeck.gui.login.welcome' => 'Weclome to Rundeck'
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
          gui_config: gui_config_hash
        }
      end

      # content and meta data for passwords
      it 'generates gui_config content for rundeck-config.groovy' do
        content = catalogue.resource('file', '/etc/rundeck/rundeck-config.groovy')[:content]
        expect(content).to include('rundeck.gui.title = "Test title"')
        expect(content).to include('rundeck.gui.brand.html = "<b>App</b>"')
        expect(content).to include('rundeck.gui.logo = "test-logo.png"')
        expect(content).to include('rundeck.gui.login.welcome = "Weclome to Rundeck"')
      end
    end
  end
end
