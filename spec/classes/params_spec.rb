require 'spec_helper'

describe 'rundeck' do
  describe '\'serialnumber\' fact present' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        serialnumber: 'rea8CTp2ed'
      }
    end

    it { should contain_file('/etc/rundeck/framework.properties') }
    it 'uses serialnumber fact for \'rundeck.server.uuid\'' do
      content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
      expect(content).to include('rundeck.server.uuid = rea8CTp2ed')
    end
  end

  describe '\'serialnumber\' fact not present' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        fqdn: 'somehost.example.com'
      }
    end

    it { should contain_file('/etc/rundeck/framework.properties') }
    it 'generates a random uuid for \'rundeck.server.uuid\'' do
      content = catalogue.resource('file', '/etc/rundeck/framework.properties')[:content]
      expect(content).to include('rundeck.server.uuid = 5pWDei3ENj')
    end
  end
end
