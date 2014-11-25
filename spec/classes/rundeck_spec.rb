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

        it { should contain_class('rundeck::params') }
        it { should contain_class('rundeck::install').that_comes_before('rundeck::config') }
        it { should contain_class('rundeck::config') }
        it { should contain_class('rundeck::service').that_comes_before('rundeck') }
        it { should contain_class('rundeck').that_requires('rundeck::service') }

        if osfamily.eql?('RedHat')
          it { should contain_package('java-1.6.0-openjdk') }
        else
          it { should contain_package('openjdk-6-jre') }
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'rundeck class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
        :serialnumber    => 0,
        :rundeck_version => ''
      }}

      it { expect { should contain_package('rundeck') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
