require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::global::rundeck_config class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
          :fqdn => 'test.domain.com'
        }}

        $default_config = <<-CONFIG.gsub /[^\S\n]{10}/, ""
          loglevel.default = "INFO"
          rdeck.base = "/var/lib/rundeck"
          rss.enabled = "false"

          rundeck.security.useHMacRequestTokens = true
          rundeck.security.apiCookieAccess.enabled = true

          dataSource {
            dbCreate = "update"
            url = "jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true"
          }

          grails {
          }

          grails.serverURL = "http://test.domain.com:4440"
          rundeck.clusterMode.enabled = "false"
        CONFIG

        it { should contain_file('/etc/rundeck/rundeck-config.groovy').with(
          'content' => $default_config
        )}

      end
    end
  end
end
