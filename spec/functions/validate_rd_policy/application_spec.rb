require 'spec_helper'

describe 'validate_rd_policy' do
  describe 'application policy' do
    describe 'valid policy' do
      test_policy = {
        'description' => 'Admin, all access',
        'context' => {
          'application' => 'rundeck'
        },
        'for' => {
          'resource' => [
            { 'equals' => { 'kind' => 'project' }, 'allow' => ['create'] }
          ]
        },
        'by' => [{
          'group' => ['admin']
        }]
      }

      it { is_expected.to run.with_params(test_policy) }
    end

    describe 'invalid policy' do
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{}) }

      context 'description' do
        it do
          is_expected.to run.with_params('context' => {
                                           'application' => 'rundeck'
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - description is not a String')
        end

        it do
          is_expected.to run.with_params('description' => {}).and_raise_error(Puppet::ParseError, 'The policy is invalid - description is not a String')
        end
      end

      context 'context' do
        it do
          is_expected.to run.with_params('description' => 'test').and_raise_error(Puppet::ParseError, 'The policy is invalid - context is not a Hash')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {}).and_raise_error(Puppet::ParseError, 'The policy is invalid - context is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => '').and_raise_error(Puppet::ParseError, 'The policy is invalid - context is not a Hash')
        end
      end

      context 'context:application' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'fubar' => ''
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context can only be project or application')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => {}
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context:application is not a String')
        end
      end

      context 'for' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => '').and_raise_error(Puppet::ParseError, 'The policy is invalid - for is not a Hash')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {}).and_raise_error(Puppet::ParseError, 'The policy is invalid - for is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'fubar' => {}
                                         }).and_raise_error(Puppet::ParseError, "The policy is invalid - for section must only contain ['resource', 'project', 'storage']")
        end
      end

      context 'for:resource' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => ''
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => {}
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => []
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [{}]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource does not contain a rule action of [allow,deny]')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'job' }, 'allow' => ['admin'] },
                                             ''
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource entry is not a Hash')
        end
      end

      context 'for:resource rules' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'job' }, 'fubar' => ['admin'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource does not contain a rule action of [allow,deny]')
        end
      end

      context 'for:resource matching' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'fubar' => { 'kind' => 'job' }, 'deny' => ['admin'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:resource does not contain a matching statement of [match,equals,contains]')
        end
      end

      context 'for:resource kind:project' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'project' }, 'allow' => ['x'] }
                                           ]
                                         },
                                         'by' => [{ 'group' => 'admins' }]).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:resource kind:project can only contain actions})
        end
      end

      context 'for:resource kind:system' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'system' }, 'allow' => ['x'] }
                                           ]
                                         },
                                         'by' => [{ 'group' => 'admins' }]).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:resource kind:system can only contain actions})
        end
      end

      context 'for:resource kind:user' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'user' }, 'allow' => ['x'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:resource kind:user can only contain actions})
        end
      end

      context 'for:resource kind:job' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'resource' => [
                                             { 'equals' => { 'kind' => 'job' }, 'allow' => ['x'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:resource kind:job can only contain actions})
        end
      end

      context 'for:project' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => ''
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => {}
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => []
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [{}]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project does not contain a rule action of [allow,deny]')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'allow' => ['create'] },
                                             ''
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project entry is not a Hash')
        end
      end

      context 'for:project rules' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'fubar' => ['read'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project does not contain a rule action of [allow,deny]')
        end
      end

      context 'for:project matching' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'fubar' => { 'name' => 'test' }, 'deny' => ['read'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:project does not contain a matching statement of [match,equals,contains]')
        end
      end

      context 'for:project property:name' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['x'] }
                                           ]
                                         },
                                         'by' => [{ 'group' => 'admins' }]).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:project name can only contain actions})
        end
      end

      context 'for:storage' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => ''
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => {}
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => []
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [{}]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage does not contain a rule action of [allow,deny]')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [
                                             { 'allow' => ['create'] },
                                             ''
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage entry is not a Hash')
        end
      end

      context 'for:storage rules' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [
                                             { 'equals' => { 'name' => 'test' }, 'fubar' => ['read'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage does not contain a rule action of [allow,deny]')
        end
      end

      context 'for:storage matching' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [
                                             { 'fubar' => { 'name' => 'test' }, 'deny' => ['read'] }
                                           ]
                                         }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for:storage does not contain a matching statement of [match,equals,contains]')
        end
      end

      context 'for:storage property:name' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['x'] }
                                           ]
                                         },
                                         'by' => [{ 'group' => 'admins' }]).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:storage name can only contain actions})
        end
      end

      context 'for:storage property:path' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'storage' => [
                                             { 'equals' => { 'path' => 'test' }, 'allow' => ['x'] }
                                           ]
                                         },
                                         'by' => [{ 'group' => 'admins' }]).and_raise_error(Puppet::ParseError, %r{^The policy is invalid - for:storage path can only contain actions})
        end
      end

      context 'by' do
        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['read'] }
                                           ]
                                         },
                                         'by' => '').and_raise_error(Puppet::ParseError, 'The policy is invalid - by is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['read'] }
                                           ]
                                         },
                                         'by' => {}).and_raise_error(Puppet::ParseError, 'The policy is invalid - by is not an Array')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['read'] }
                                           ]
                                         },
                                         'by' => []).and_raise_error(Puppet::ParseError, 'The policy is invalid - by is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['read'] }
                                           ]
                                         },
                                         'by' => [{}]).and_raise_error(Puppet::ParseError, 'The policy is invalid - by is empty')
        end

        it do
          is_expected.to run.with_params('description' => 'test',
                                         'context'     => {
                                           'application' => 'rundeck'
                                         },
                                         'for' => {
                                           'project' => [
                                             { 'equals' => { 'name' => 'test' }, 'allow' => ['read'] }
                                           ]
                                         },
                                         'by' => [{ 'username' => 'test' }, '']).and_raise_error(Puppet::ParseError, 'The policy is invalid - by: is not a Hash')
        end
      end
    end
  end
end
