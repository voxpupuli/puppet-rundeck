require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily        => osfamily,
          :serialnumber    => 0,
          :rundeck_version => ''
        }}

        if osfamily.eql?('RedHat')
          it { should contain_yumrepo('bintray-rundeck') }
        else
          it { should contain_exec('download rundeck package') }
          it { should contain_exec('install rundeck package') }
          it { should_not contain_yumrepo('bintray-rundeck') }
        end

        it { should contain_file('/var/lib/rundeck').with(
          'ensure' => 'directory'
        )}

        it { should contain_user('rundeck').with(
          'ensure' => 'present'
        )}
     end
    end
  end

  describe 'different user and group' do 
    let(:params) {{
      :user  => 'A1234',
      :group => 'A1234'
    }}
    let(:facts) {{
      :osfamily        => 'Debian',
      :serialnumber    => 0,
      :rundeck_version => ''
    }}

    it { should contain_group('A1234').with(
      'ensure' => 'present'
    )}

    it { should contain_group('rundeck').with(
      'ensure' => 'absent'
    )}

    it { should contain_user('A1234').with(
      'ensure' => 'present'
    )}

    it { should contain_user('rundeck').with(
      'ensure' => 'absent'
    )} 
  end
end
