require 'spec_helper'

describe 'rundeck::config::aclpolicyfile', type: :define do
  test_policies = [
    {
      'description' => 'Admin, all access',
      'context' => {
        'project' => '.*'
      },
      'for' => {
        'resource' => [
          { 'equals' => { 'kind' => 'job' }, 'allow' => ['create'] }
        ]
      },
      'by' => [
        { 'group' => ['admin'] }
      ]
    },
    {
      'description' => 'Admin, all access',
      'context' => {
        'application' => 'rundeck'
      },
      'for' => {
        'resource' => [
          { 'equals' => { 'kind' => 'project' }, 'allow' => ['create'] }
        ]
      },
      'by' => [
        { 'groups' => ['admin'] }
      ]
    }
  ]

  context 'default parameters' do
    let(:title) { 'defaultPolicy' }
    let(:params) do
      {
        acl_policies: test_policies
      }
    end

    it do
      should contain_file('/etc/rundeck/defaultPolicy.aclpolicy').with('owner' => 'rundeck',
                                                                       'group' => 'rundeck',
                                                                       'mode'  => '0640')
    end
  end

  context 'custom parameters' do
    let(:title) { 'myPolicy' }
    let(:params) do
      {
        acl_policies: test_policies,
        properties_dir: '/etc/rundeck-acl',
        owner: 'myUser',
        group: 'myGroup'
      }
    end

    it do
      should contain_file('/etc/rundeck-acl/myPolicy.aclpolicy').with('owner' => 'myUser',
                                                                      'group' => 'myGroup',
                                                                      'mode'  => '0640')
    end
  end
end
