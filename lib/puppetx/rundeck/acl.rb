
module PuppetX
  # Module to capture all untility extensions for the Rundeck puppet module
  module Rundeck
    # Module to check ACL validity
    module ACL
      # RundeckValidator class
      class RundeckValidator
        def raise_err(msg)
          raise(Puppet::ParseError, "The policy is invalid - #{msg}")
        end

        def validate_rule_action(type, type_section, scope)
          action_found = false
          actions = []
          property = ''
          value = ''

          raise_err("for:#{type} is empty") if type_section.empty?
          type_section.each do |e|
            raise_err("for:#{type} entry is not a Hash") unless e.is_a? Hash
          end
          type_section.each do |e|
            e.each do |k, v|
              if k.eql?('allow') || k.eql?('deny')
                action_found = true
                actions = v
              elsif %w[match equals contains].include?(k)
                case type
                when 'resource'
                  property = v['kind']
                when 'job'
                  if v['name']
                    property = 'name'
                    value = v['name']
                  elsif v['group']
                    property = 'group'
                    value = v['group']
                  else
                    property = v.keys[0]
                  end
                when 'project'
                  if v['name']
                    property = 'name'
                    value = v['name']
                  else
                    property = v.keys[0]
                  end
                when 'storage'
                  if v['name']
                    property = 'name'
                    value = v['name']
                  elsif v['path']
                    property = 'path'
                    value = v['path']
                  else
                    property = v.keys[0]
                  end
                end
              end
            end
            raise_err("for:#{type} does not contain a rule action of [allow,deny]") unless action_found
            if scope.eql?('project')
              validate_proj_actions(type, actions, property, value) if property.to_s != '' || type.eql?('adhoc') || type.eql?('node')
            elsif scope.eql?('application')
              validate_app_actions(type, actions, property, value)
            end
          end
        end

        def validate_proj_actions(type, actions, property, value = '')
          project_actions = {
            'resource' => {
              'job'   => %w[create delete],
              'node'  => %w[read create update refresh],
              'event' => %w[read create]
            },
            'adhoc' => %w[read run runAs kill killAs],
            'job' => {
              'name' => %w[read update delete run runAs kill killAs create],
              'group' => %w[read update delete run runAs kill killAs create]
            },
            'node' => %w[read run]
          }

          case type
          when 'resource'
            case property
            when 'job', 'node', 'event'
              actions.each do |action|
                unless project_actions[type][property].include?(action)
                  raise_err("for:resource kind:#{property} can only contain actions #{project_actions[type][property]}")
                end
              end
            end
          when 'adhoc', 'node'
            actions.each do |action|
              raise_err("for:#{type} can only contain actions #{project_actions[type]}") unless project_actions[type].include?(action)
            end
          when 'job'
            case property
            when 'name', 'group'
              actions.each do |action|
                raise_err("for:job #{property}:#{value} can only contain actions #{project_actions[type][property]}") unless project_actions[type][property].include?(action)
              end
            else
              raise_err("#{property} is not a valid property for the job scope")
            end
          end
        end

        def validate_app_actions(type, actions, property, _value = '')
          app_actions = {
            'resource' => {
              'project' => ['create'],
              'system'  => ['read'],
              'user'    => ['admin'],
              'job'     => ['admin']
            },
            'project' => { 'name' => %w[read configure delete import export delete_execution admin] },
            'storage' => {
              'name' => %w[create update read delete],
              'path' => %w[create update read delete]
            }
          }

          case type
          when 'resource'
            case property
            when 'project', 'system', 'user', 'job'
              actions.each do |action|
                raise_err("for:resource kind:#{property} can only contain actions #{app_actions[type][property]}") unless app_actions[type][property].include? action
              end
            end
          when 'project'
            if property.eql?('name')
              actions.each do |action|
                raise_err("for:project #{property} can only contain actions #{app_actions[type][property]}") unless app_actions[type][property].include? action
              end
            end
          when 'storage'
            case property
            when 'name', 'path'
              actions.each do |action|
                raise_err("for:storage #{property} can only contain actions #{app_actions[type][property]}") unless app_actions[type][property].include? action
              end
            end
          end
        end

        def validate_matching(type, type_section)
          unless (%w[match equals contains] & type_section.keys).length >= 1
            raise_err("for:#{type} does not contain a matching statement of [match,equals,contains]")
          end
        end

        def validate_for(for_section)
          for_section.each do |type, value|
            validate_rule_action(type, value, scope)
            validate_matching(type, value) unless value.eql?('adhoc')
          end
        end
      end

      def validate_acl(hash)
        rv = RundeckValidator.new
        rv.validate_for(hash['for'])
      end
      module_function :validate_acl
    end
  end
end
