require 'spec_helper'

describe 'rundeck::config::resource_source', :type => :define do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::resource_source definition with default parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) {{
          'project_name' => 'test',
          'source_type' => 'file',
          'include_server_node' => false,
          'resource_format' => 'resourcexml',
        }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        file_details = {
          'resources.source.1.config.requireFileExists' => 'true',
          'resources.source.1.config.includeServerNode' => 'false',
          'resources.source.1.config.generateFileAutomatically' => 'true',
          'resources.source.1.config.format' => 'resourcexml',
          'resources.source.1.config.file' => '/var/rundeck/projects/test/etc/resources.xml',
          'resources.source.1.type' => 'file'
        }

        file_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/var/rundeck/projects/test/etc/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end
      end

      describe "rundeck::config::resource_source definition with url parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) {{
            'project_name' => 'test',
            'source_type' => 'url',
            'url' => 'http\://localhost\:9999',
            'include_server_node' => true,
            'url_cache' => true,
            'url_timeout' => '30',
        }}
        let(:facts) {{
          :osfamily     => osfamily,
          :serialnumber => 0
        }}

        url_details = {
          'resources.source.1.config.url' => 'http\://localhost\:9999',
          'resources.source.1.config.timeout' => '30',
          'resources.source.1.config.cache' => 'true',
          'resources.source.1.type' => 'url'
        }

        url_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/var/rundeck/projects/test/etc/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end
      end

      describe "rundeck::config::resource definition with directory parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) {{
            'project_name' => 'test',
            'source_type' => 'directory',
            'directory' => '/fubar/resources',
            'include_server_node' => true,
        }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        directory_details = {
          'resources.source.1.config.directory' => '/fubar/resources',
          'resources.source.1.type' => 'directory'
        }

        directory_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/var/rundeck/projects/test/etc/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end
      end

      describe "rundeck::config::resource definition with script parameters on #{osfamily}" do
        let(:title) { 'source one' }
        let(:params) {{
            'project_name' => 'test',
            'source_type' => 'script',
            'script_file' => '/fubar/test.sh',
            'script_args' => 'fubar',
            'include_server_node' => true,
            'resource_format' => 'resourcexml',
            'script_args_quoted' => true,
            'script_interpreter' => '/bin/bash',
        }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}


        script_details = {
          'resources.source.1.config.file' => '/fubar/test.sh',
          'resources.source.1.config.interpreter' => '/bin/bash',
          'resources.source.1.config.format' => 'resourcexml',
          'resources.source.1.config.args' => 'fubar',
          'resources.source.1.config.argsQuoted' => true,
          'resources.source.1.type' => 'script'
        }

        script_details.each do |key,value|
          it { should contain_ini_setting(key).with(
            'path'    => '/var/rundeck/projects/test/etc/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end
      end
    end
  end
end
