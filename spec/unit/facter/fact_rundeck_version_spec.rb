# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact do
  before { Facter.clear }

  context 'no rundeck installed | no rd-acl in path' do
    before { allow(Facter::Core::Execution).to receive('which').with('rd-acl').and_return(false) }

    it { expect(Facter.fact('rundeck_version')).to be_nil }
    it { expect(Facter.fact('rundeck_commitid')).to be_nil }
  end

  context 'rundeck installed | rd-acl in path with current output format' do
    before do
      allow(Facter::Core::Execution).to receive('which').with('rd-acl').and_return(true)
      allow(Facter::Core::Execution).to receive('execute').with('rd-acl -h').and_return('[RUNDECK version 3.0.6-20180917 (0)]')
    end

    it { expect(Facter.fact('rundeck_version').value).to eq('3.0.6') }
    it { expect(Facter.fact('rundeck_commitid').value).to eq('20180917') }
  end

  context 'rundeck installed | rd-acl in path with old output format' do
    before do
      allow(Facter::Core::Execution).to receive('which').with('rd-acl').and_return(true)
      allow(Facter::Core::Execution).to receive('execute').with('rd-acl -h').and_return('[RUNDECK version 2.0.0 (0)]')
    end

    it { expect(Facter.fact('rundeck_version').value).to eq('2.0.0') }
    it { expect(Facter.fact('rundeck_commitid').value).to eq('') }
  end
end
