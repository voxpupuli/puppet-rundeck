require 'spec_helper'

describe 'rundeck::config::resource_source', type: :define do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::resource_source definition with default parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'project_name' => 'test',
            'source_type' => 'file',
            'include_server_node' => false,
            'resource_format' => 'resourcexml',
            'url_cache' => true,
            'url_timeout' => '50',
            'directory' => '/',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash'
          }
        end
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        file_details = {
          'resources.source.1.config.requireFileExists' => 'true',
          'resources.source.1.config.includeServerNode' => 'false',
          'resources.source.1.config.generateFileAutomatically' => 'true',
          'resources.source.1.config.format' => 'resourcexml',
          'resources.source.1.config.file' => '/var/lib/rundeck/projects/test/etc/source one.xml',
          'resources.source.1.type' => 'file'
        }

        file_details.each do |key, value|
          it do
            should contain_ini_setting("source one::#{key}").with(
              'path'    => '/var/lib/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end

        it do
          should contain_file('/var/lib/rundeck/projects/test').with(
            'owner' => 'rundeck',
            'group' => 'rundeck'
          )
        end
      end

      describe "rundeck::config::resource_source definition with url parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'project_name' => 'test',
            'source_type' => 'url',
            'url' => 'http\://localhost\:9999',
            'include_server_node' => true,
            'url_cache' => true,
            'url_timeout' => '50',
            'directory' => '/',
            'resource_format' => 'resourcexml',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash'
          }
        end
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            puppetversion: Puppet.version,
            rundeck_version: ''
          }
        end

        url_details = {
          'resources.source.1.config.url' => 'http\://localhost\:9999',
          'resources.source.1.config.timeout' => '50',
          'resources.source.1.config.cache' => 'true',
          'resources.source.1.type' => 'url'
        }

        url_details.each do |key, value|
          it do
            should contain_ini_setting("source one::#{key}").with(
              'path'    => '/var/lib/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end

      describe "rundeck::config::resource definition with directory parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'project_name' => 'test',
            'source_type' => 'directory',
            'directory' => '/fubar/resources',
            'include_server_node' => true,
            'resource_format' => 'resourcexml',
            'url_cache' => true,
            'url_timeout' => '50',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash'

          }
        end
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        directory_details = {
          'resources.source.1.config.directory' => '/fubar/resources',
          'resources.source.1.type' => 'directory'
        }

        directory_details.each do |key, value|
          it do
            should contain_ini_setting("source one::#{key}").with(
              'path'    => '/var/lib/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end

      describe "rundeck::config::resource definition with script parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'project_name' => 'test',
            'source_type' => 'script',
            'script_file' => '/fubar/test.sh',
            'script_args' => 'fubar',
            'include_server_node' => true,
            'resource_format' => 'resourcexml',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash',
            'url_cache' => true,
            'url_timeout' => '30',
            'directory' => '/'
          }
        end
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        script_details = {
          'resources.source.1.config.file' => '/fubar/test.sh',
          'resources.source.1.config.interpreter' => '/bin/bash',
          'resources.source.1.config.format' => 'resourcexml',
          'resources.source.1.config.args' => 'fubar',
          'resources.source.1.config.argsQuoted' => true,
          'resources.source.1.type' => 'script'
        }

        script_details.each do |key, value|
          it do
            should contain_ini_setting("source one::#{key}").with(
              'path'    => '/var/lib/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end

      describe "rundeck::config::resource definition with Puppet Enterprise parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) do
          {
            'project_name' => 'test',
            'include_server_node' => false,
            'resource_format' => 'resourcexml',
            'url_cache' => true,
            'url_timeout' => '50',
            'directory' => '/foo/bar/resources',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash',

            'source_type' => 'puppet-enterprise',
            'puppet_enterprise_host' => 'localhost',
            'puppet_enterprise_port' => '8081',
            'puppet_enterprise_mapping_file' => '/var/local/resource-mapping.json',
            'puppet_enterprise_metrics_interval' => '15'
          }
        end
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: Puppet.version
          }
        end

        puppet_enterprise_details = {
          'resources.source.1.type' => 'puppet-enterprise',
          'resources.source.1.config.PROPERTY_PUPPETDB_HOST' => 'localhost',
          'resources.source.1.config.PROPERTY_PUPPETDB_PORT' => '8081',
          'resources.source.1.config.PROPERTY_METRICS_INTERVAL' => '15',
          'resources.source.1.config.PROPERTY_MAPPING_FILE' => '/var/local/resource-mapping.json'
        }

        puppet_enterprise_details.each do |key, value|
          it do
            should contain_ini_setting("source one::#{key}").with(
              'path'    => '/var/lib/rundeck/projects/test/etc/project.properties',
              'setting' => key,
              'value'   => value
            )
          end
        end
      end
    end
  end
end
