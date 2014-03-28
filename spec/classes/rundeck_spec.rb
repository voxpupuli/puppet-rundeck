require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "rundeck class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        #it { should compile.with_all_deps }

        it { should contain_class('rundeck::params') }
        it { should contain_class('rundeck::install').that_comes_before('rundeck::config') }
        it { should contain_class('rundeck::config') }
        it { should contain_class('rundeck::service').that_subscribes_to('rundeck::config') }

        it { should contain_service('rundeckd') }
        #it { should contain_package('rundeck').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'rundeck class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('rundeck') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
