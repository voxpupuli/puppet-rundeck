require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            :osfamily        => osfamily,
            :serialnumber    => 0,
            :rundeck_version => '',
            :puppetversion   => Puppet.version
          }
        end
        it { should contain_service('rundeckd') }
      end
    end
  end
end
