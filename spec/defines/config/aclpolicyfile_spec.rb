require 'spec_helper'

describe 'rundeck::config::aclpolicyfile', :type => :define do

    let(:title) {'myPolicy'}
    let(:params) {{
        :acl_policies   =>
          [
              {
                'description' => 'Admin, all access',
                'context' => {
                  'type' => 'project',
                  'rule' => '.*'
                },
                'resource_types' => [
                  { 'type'  => 'resource', 'rules' => [{'name' => 'allow','rule' => '*'}] }
                ],
                'by' => {
                  'groups'    => ['admin'],
                }
              },
              {
                'description' => 'Admin, all access',
                'context' => {
                  'type' => 'application',
                  'rule' => 'rundeck'
                },
                'resource_types' => [
                  { 'type'  => 'resource', 'rules' => [{'name' => 'allow','rule' => '*'}] }
                ],
                'by' => {
                  'groups'    => ['admin'],
                }
              }
          ],
        :properties_dir => '/etc/rundeck',
        :owner => 'myUser',
        :group => 'myGroup',
		}}

    it { should contain_file('/etc/rundeck/myPolicy.aclpolicy').with(
          {
            'owner' => 'myUser',
            'group' => 'myGroup',
            'mode' => '0640',
          }
    )}

end

