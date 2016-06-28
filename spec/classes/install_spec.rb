require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            serialnumber: 0,
            rundeck_version: '',
            puppetversion: '3.8.1'
          }
        end
        plugin_dir = '/var/lib/rundeck/libext'

        if osfamily.eql?('RedHat')
          it { should contain_yumrepo('bintray-rundeck') }
        else
          it { should contain_exec('download rundeck package') }
          it { should contain_exec('install rundeck package') }
          it { should_not contain_yumrepo('bintray-rundeck') }
        end

        it do
          should contain_file('/var/lib/rundeck').with(
            'ensure' => 'directory'
          )
        end

        it do
          should contain_file(plugin_dir).with(
            'ensure' => 'directory'
          )
        end

        it do
          should contain_user('rundeck').with(
            'ensure' => 'present'
          )
        end
      end
    end
  end

  describe 'different user and group' do
    let(:params) do
      {
        user: 'A1234',
        group: 'A1234'
      }
    end
    let(:facts) do
      {
        osfamily: 'Debian',
        serialnumber: 0,
        rundeck_version: '',
        puppetversion: '3.8.1'
      }
    end

    it do
      should contain_group('A1234').with(
        'ensure' => 'present'
      )
    end

    it do
      should contain_group('rundeck').with(
        'ensure' => 'absent'
      )
    end

    it do
      should contain_user('A1234').with(
        'ensure' => 'present'
      )
    end

    it do
      should contain_user('rundeck').with(
        'ensure' => 'absent'
      )
    end
  end
end
