require 'spec_helper'

describe 'rundeck::config' do
  let(:facts) {{
      :osfamily => 'Debian'
  }}

  it { should contain_anchor('rundeck::config::begin') }
  it { should contain_class('rundeck::config::global::framework') }
  it { should contain_class('rundeck::config::global::project') }
  it { should contain_class('rundeck::config::global::rundeck_config') }
  it { should contain_class('rundeck::config::global::ssl') }
  it { should contain_anchor('rundeck::config::end') }

end