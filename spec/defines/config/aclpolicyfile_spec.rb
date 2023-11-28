# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck::config::aclpolicyfile', type: :define do
  admin_policy = [
    {
      'description' => 'Admin, all access',
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
        { 'group' => ['admin'] }
      ],
    },
    {
      'description' => 'Admin, all access',
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
        { 'group' => ['admin'] }
      ]
    }
  ]

  admin_acl = <<~CONFIG.gsub(%r{[^\S\n]{10}}, '')
    description: Admin, all access
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

    description: Admin, all access
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
        - 'admin'
  CONFIG

  context 'with admin acl and default parameters' do
    let(:title) { 'admin' }
    let(:params) do
      {
        acl_policies: admin_policy,
      }
    end

    it {
      is_expected.to contain_file('/etc/rundeck/admin.aclpolicy').with(
        owner: 'rundeck',
        group: 'rundeck',
        mode: '0644',
        content: admin_acl
      )
    }
  end

  context 'with admin acl and custom parameters' do
    let(:title) { 'admin' }
    let(:params) do
      {
        acl_policies: admin_policy,
        properties_dir: '/etc/rundeck-acl',
        owner: 'myUser',
        group: 'myGroup'
      }
    end

    it {
      is_expected.to contain_file('/etc/rundeck-acl/admin.aclpolicy').with(
        owner: 'myUser',
        group: 'myGroup',
        mode: '0644',
        content: admin_acl
      )
    }
  end
end
