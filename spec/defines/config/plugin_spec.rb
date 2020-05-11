require 'spec_helper'

describe 'rundeck::config::plugin', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck::config::plugin definition without any parameters on #{os}" do
        name = 'rundeck-hipchat-plugin-1.0.0.jar'
        source = 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar'
        plugin_dir = '/var/lib/rundeck/libext'

        let(:title) { name }
        let(:params) do
          {
            'source' => source
          }
        end

        it do
          is_expected.to contain_archive("download plugin #{name}").with(
            'source' => 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar'
          )
        end

        it do
          is_expected.to contain_file("#{plugin_dir}/#{name}").with(
            'mode'   => '0644',
            'owner'  => 'rundeck',
            'group'  => 'rundeck'
          )
        end
      end

      describe "rundeck::config::plugin definition with ensure set to absent on #{os}" do
        name = 'rundeck-hipchat-plugin-1.0.0.jar'
        source = 'http://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.0.0/rundeck-hipchat-plugin-1.0.0.jar'
        plugin_dir = '/var/lib/rundeck/libext'

        let(:title) { name }
        let(:params) do
          {
            'source' => source,
            'ensure' => 'absent'
          }
        end

        it do
          is_expected.to contain_file("#{plugin_dir}/#{name}").with(
            'ensure' => 'absent'
          )
        end
      end
    end
  end
end
