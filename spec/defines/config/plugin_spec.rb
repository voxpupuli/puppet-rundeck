require 'spec_helper'

describe 'rundeck::config::plugin', :type => :define do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::plugin definition without any parameters on #{osfamily}" do
        name = 'rundeck-hipchat-plugin-1.0.0.jar'
        source = 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar'
        plugin_dir = '/var/lib/rundeck/libext'

        let(:title) { name }
        let(:params) {{
          'source' => source
        }}

        let(:facts) {{
          :osfamily        => 'Debian',
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        it { should contain_file(plugin_dir).with(
          'ensure' => 'directory'
        ) }

        it { should contain_exec("download plugin #{name}").with(
          'command' => "/usr/bin/wget #{source} -O #{plugin_dir}/#{name}"
        ) }

        it { should contain_file("#{plugin_dir}/#{name}").with(
          'ensure' => 'present',
          'mode'   => '0644',
          'owner'  => 'rundeck',
          'group'  => 'rundeck'
        )}
      end
    end
  end
end
