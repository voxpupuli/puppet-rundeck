require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      feature_config_hash = {
        'feature.incubator.parallelWorkflowStrategy' => true
      }

      let(:facts) do
        {
          :osfamily        => osfamily,
          :fqdn            => 'test.domain.com',
          :serialnumber    => 0,
          :rundeck_version => '',
          :puppetversion   => Puppet.version
        }
      end

      let(:params) do
        {
          :feature_config => feature_config_hash
        }
      end

      # content and meta data for passwords
      it 'should generate feature_config content for rundeck-config.groovy' do
        content = catalogue.resource('file', '/etc/rundeck/rundeck-config.groovy')[:content]
        expect(content).to include('feature.incubator.parallelWorkflowStrategy = true')
      end
    end
  end
end
