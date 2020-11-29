require 'spec_helper'

describe Facter::Util::Fact do
  before { Facter.clear }

  context 'no rundeck installed | no rd-acl in path' do
    before { allow(Facter::Util::Resolution).to receive('which').with('rd-acl') { false } }
    it { expect(Facter.fact('rundeck_version')).to eq(nil) }
    it { expect(Facter.fact('rundeck_commitid')).to eq(nil) }
  end

  context 'rundeck installed | rd-acl in path with current output format' do
    before do
      allow(Facter::Util::Resolution).to receive('which').with('rd-acl') { true }
      allow(Facter::Util::Resolution).to receive('exec').with('rd-acl -h') do
        '[RUNDECK version 3.0.6-20180917 (0)]'
      end
    end

    it { expect(Facter.fact('rundeck_version').value).to eq('3.0.6') }
    it { expect(Facter.fact('rundeck_commitid').value).to eq('20180917') }
  end

  context 'rundeck installed | rd-acl in path with old output format' do
    before do
      allow(Facter::Util::Resolution).to receive('which').with('rd-acl') { true }
      allow(Facter::Util::Resolution).to receive('exec').with('rd-acl -h') do
        '[RUNDECK version 2.0.0 (0)]'
      end
    end

    it { expect(Facter.fact('rundeck_version').value).to eq('2.0.0') }
    it { expect(Facter.fact('rundeck_commitid').value).to eq('') }
  end
end
