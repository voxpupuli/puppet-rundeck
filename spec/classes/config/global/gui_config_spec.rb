require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          gui_config: {
            'rundeck.gui.title'         => 'Test title',
            'rundeck.gui.brand.html'    => '<b>App</b>',
            'rundeck.gui.logo'          => 'test-logo.png',
            'rundeck.gui.login.welcome' => 'Weclome to Rundeck'
          }
        }
      end

      # content and meta data for passwords
      it 'generates gui_config content for rundeck-config.groovy' do
        is_expected.to contain_file('/etc/rundeck/rundeck-config.groovy').
          with_content(%r{rundeck.gui.title = "Test title"}).
          with_content(%r{rundeck.gui.brand.html = "<b>App</b>"}).
          with_content(%r{rundeck.gui.logo = "test-logo.png"}).
          with_content(%r{rundeck.gui.login.welcome = "Weclome to Rundeck"})
      end
    end
  end
end
