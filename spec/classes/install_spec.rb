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
        plugin_dir = '/var/lib/rundeck/libext'

        if osfamily.eql?('RedHat')
          it { is_expected.to contain_yumrepo('bintray-rundeck') }
        else
          it { is_expected.to contain_exec('download rundeck package') }
          it { is_expected.to contain_exec('install rundeck package') }
          it { is_expected.not_to contain_yumrepo('bintray-rundeck') }
        end

        it do
          is_expected.to contain_file('/var/lib/rundeck').with(
            'ensure' => 'directory'
          )
        end

        it do
          is_expected.to contain_file(plugin_dir).with(
            'ensure' => 'directory'
          )
        end

        it do
          is_expected.to contain_user('rundeck').with(
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
        lsbdistid: 'debian',
        serialnumber: 0,
        rundeck_version: '',
        puppetversion: '3.8.1'
      }
    end

    it do
      is_expected.to contain_group('A1234').with(
        'ensure' => 'present'
      )
    end

    it do
      is_expected.to contain_group('rundeck').with(
        'ensure' => 'absent'
      )
    end

    it do
      is_expected.to contain_user('A1234').with(
        'ensure' => 'present'
      )
    end

    it do
      is_expected.to contain_user('rundeck').with(
        'ensure' => 'absent'
      )
    end
  end
  describe 'different user and group with ids' do
    let(:params) do
      {
        user: 'A1234',
        group: 'A1234',
        user_id: '10000',
        group_id: '10000'
      }
    end
    let(:facts) do
      {
        osfamily: 'Debian',
        lsbdistid: 'debian',
        serialnumber: 0,
        rundeck_version: '',
        puppetversion: '3.8.1'
      }
    end
    it do
      is_expected.to contain_group('A1234').with(
        'ensure' => 'present',
        'gid' => '10000'
      )
    end

    it do
      is_expected.to contain_user('A1234').with(
        'ensure' => 'present',
        'gid' => '10000',
        'uid' => '10000'
      )
    end
  end
end
