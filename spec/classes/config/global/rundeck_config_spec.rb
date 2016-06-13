require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::rundeck_config class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            fqdn: 'test.domain.com',
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        default_config = <<-CONFIG.gsub(%r{[^\S\n]{10}}, '')
          loglevel.default = "INFO"
          rdeck.base = "/var/lib/rundeck"
          rss.enabled = "false"

          rundeck.security.useHMacRequestTokens = true
          rundeck.security.apiCookieAccess.enabled = true

          dataSource {
            dbCreate = "update"
            url = "jdbc:h2:file:/var/lib/rundeck/data/rundeckdb;MVCC=true"
          }

          grails.serverURL = "http://test.domain.com:4440"
          rundeck.clusterMode.enabled = "false"

          rundeck.projectsStorageType = "filesystem"

          rundeck.storage.provider."1".type = "file"
          rundeck.storage.provider."1".config.baseDir = "/var/lib/rundeck/var/storage"
          rundeck.storage.provider."1".path = "/"

          rundeck.security.authorization.preauthenticated.enabled = "false"
          rundeck.security.authorization.preauthenticated.attributeName = "REMOTE_USER_GROUPS"
          rundeck.security.authorization.preauthenticated.delimiter = ":"

        CONFIG

        it do
          should contain_file('/etc/rundeck/rundeck-config.groovy').with(
            'content' => default_config
          )
        end
      end
    end
  end
end
