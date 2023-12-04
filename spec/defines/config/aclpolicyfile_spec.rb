# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck::config::aclpolicyfile', type: :define do
  test_policy = [
    {
      'description' => 'Test project access',
      'context' => {
        'project' => '.*'
      },
      'for' => {
        'resource' => [
          { 'allow' => '*' }
        ],
        'adhoc' => [
          { 'allow' => '*' }
        ],
        'job' => [
          { 'allow' => '*' }
        ],
        'node' => [
          { 'allow' => '*' }
        ],
      },
      'by' => [
        { 'group' => ['test'] }
      ],
    },
    {
      'description' => 'Test application access',
      'context' => {
        'application' => 'rundeck'
      },
      'for' => {
        'project' => [
          { 'allow' => '*' }
        ],
        'resource' => [
          { 'allow' => '*' }
        ],
        'storage' => [
          { 'allow' => '*' }
        ],
      },
      'by' => [
        { 'group' => ['test'] }
      ]
    }
  ]

  test_acl = <<~CONFIG.gsub(%r{[^\S\n]{10}}, '')
    description: Test project access
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
        - 'test'

    ---

    description: Test application access
    context:
      application: 'rundeck'
    for:
      project:
        - allow: '*'
      resource:
        - allow: '*'
      storage:
        - allow: '*'
    by:
      group:
        - 'test'
  CONFIG

  context 'with test acl and default parameters' do
    let(:title) { 'test' }
    let(:params) do
      {
        acl_policies: test_policy,
      }
    end

    it {
      is_expected.to contain_file('/etc/rundeck/test.aclpolicy').with(
        owner: 'rundeck',
        group: 'rundeck',
        mode: '0644',
        content: test_acl
      )
    }
  end

  context 'with test acl and custom parameters' do
    let(:title) { 'test' }
    let(:params) do
      {
        acl_policies: test_policy,
        properties_dir: '/etc/rundeck-acl',
        owner: 'myUser',
        group: 'myGroup'
      }
    end

    it {
      is_expected.to contain_file('/etc/rundeck-acl').with(
        ensure: 'directory',
        owner: 'myUser',
        group: 'myGroup',
        mode: '0755'
      )
    }

    it {
      is_expected.to contain_file('/etc/rundeck-acl/test.aclpolicy').with(
        owner: 'myUser',
        group: 'myGroup',
        mode: '0644',
        content: test_acl
      )
    }
  end
end
