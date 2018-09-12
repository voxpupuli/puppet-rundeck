require 'spec_helper_acceptance'

describe 'rundeck class' do
  context 'default parameters' do
    it 'applies successfully' do
      pp = <<-EOS
      class { 'java':
        distribution => 'jre'
      }
      class { 'rundeck': }

      Class['java'] -> Class['rundeck']
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true, debug: true)
      apply_manifest(pp, catch_changes: true, debug: true)
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_running }
    end
  end

  context 'simple project' do
    it 'applies successfully' do
      pp = <<-EOS
      class { 'rundeck':
        projects => {
          'Wizzle' => {},
        }
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/rundeck/projects/Wizzle/etc/project.properties') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{service.FileCopier.default.provider = jsch-scp} }
    end
  end
end
