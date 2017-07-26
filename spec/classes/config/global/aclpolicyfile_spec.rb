require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe "rundeck::config::global::aclpolicyfile class without any parameters on #{os}" do
        let(:params) { {} }

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
