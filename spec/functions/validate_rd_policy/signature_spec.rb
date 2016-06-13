require 'spec_helper'

describe 'validate_rd_policy' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

    describe 'basic invalid inputs' do
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{is not a Hash or Array of hashes}) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{is not a Hash or Array of hashes}) }
      it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{is not a Hash or Array of hashes}) }
    end
  end
end
