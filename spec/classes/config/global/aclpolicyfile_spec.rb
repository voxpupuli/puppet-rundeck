require 'spec_helper'

describe 'rundeck' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "rundeck::config::global::aclpolicyfile class without any parameters on #{osfamily}" do
        lsbdistid = 'debian' if osfamily.eql?('Debian')

        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            lsbdistid: lsbdistid,
            fqdn: 'test.domain.com',
            serialnumber: 0,
            rundeck_version: ''
          }
        end

        default_acl = <<-CONFIG.gsub(%r{[^\S\n]{10}}, '')
description: 'Admin, all access'
context:
  project: '.*'
for:
  resource:
    - allow: '*'
  adhoc:
    - allow: '*'
  job:
    - allow: '*'
  node:
    - allow: '*'
by:
  group:
    - 'admin'

---

description: 'Admin, all access'
context:
  application: 'rundeck'
for:
  resource:
    - allow: '*'
  project:
    - allow: '*'
  storage:
    - allow: '*'
by:
  group:
    - 'admin'
        CONFIG

        it do
          is_expected.to contain_file('/etc/rundeck/admin.aclpolicy').with_content(default_acl)
        end
      end
    end
  end
end
