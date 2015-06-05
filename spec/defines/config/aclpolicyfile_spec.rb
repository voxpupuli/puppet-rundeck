require 'spec_helper'

describe 'rundeck::config::aclpolicyfile', :type => :define do
  
  test_policies = [
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
  ]

  context 'default parameters' do
    let(:title) { 'defaultPolicy' }
    let(:params) {{
      :acl_policies => test_policies
    }}

    it { should contain_file('/etc/rundeck/defaultPolicy.aclpolicy').with({
      'owner' => 'rundeck',
      'group' => 'rundeck',
      'mode'  => '0640',
    })}
  end

  context 'custom parameters' do
    let(:title) { 'myPolicy' }
    let(:params) {{
      :acl_policies   => test_policies,
      :properties_dir => '/etc/rundeck-acl',
      :owner          => 'myUser',
      :group          => 'myGroup',
		}}

    it { should contain_file('/etc/rundeck-acl/myPolicy.aclpolicy').with({
      'owner' => 'myUser',
      'group' => 'myGroup',
      'mode'  => '0640',
    })}
  end
end

