require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        lsbdistid = 'debian' if osfamily.eql?('Debian')

        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            lsbdistid: lsbdistid,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: '3.8.1'
          }
        end
        it { is_expected.to contain_service('rundeckd') }
      end
    end
  end
end
