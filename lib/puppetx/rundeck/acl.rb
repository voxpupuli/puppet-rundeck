
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

        def validate_description(description)
          raise_err('description is not a String') unless description.is_a? String
        end

        def validate_context(context)
          raise_err('context is not a Hash') unless context.is_a? Hash
          raise_err('context is empty') if context.empty?
          raise_err('context can only contain project or application') unless context.keys.length == 1
          type = context.keys[0]
          raise_err("context:#{type} is not a String") unless context[type].is_a? String
          raise_err('context can only be project or application') unless %w[application project].include? type
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
          matching_found = false
          raise_err("for:#{type} is empty") if type_section.empty?
          type_section.each do |e|
            if e.is_a? Hash
              e.each do |k, _v|
                matching_found = true if k.eql?('match') || k.eql?('equals') || k.eql?('contains')
              end
            else
              raise_err("for:#{type} entry is not a Hash")
            end
          end
          raise_err("for:#{type} does not contain a matching statement of [match,equals,contains]") unless matching_found
        end

        def validate_for(for_section, context)
          if !for_section.is_a? Hash
            raise_err('for is not a Hash')
          elsif for_section.empty?
            raise_err('for is empty')
          else
            scope = context.keys[0]
            if scope.eql?('project')
              resource_types = %w[job node adhoc project resource]
            elsif scope.eql?('application')
              resource_types = %w[resource project storage]
            else
              raise_err("unknown scope: #{scope}")
            end

            for_section.each do |k, _v|
              raise_err("for section must only contain #{resource_types.inspect.tr!('"', "'")}") unless resource_types.include?(k)
            end
            resource_types.each do |type|
              next unless for_section.key?(type)
              if !for_section[type].is_a? Array
                raise_err("for:#{type} is not an Array")
              elsif for_section[type].empty?
                raise_err("for:#{type} is empty")
              else
                validate_rule_action(type, for_section[type], scope)
                validate_matching(type, for_section[type]) unless for_section[type].eql?('adhoc')
              end
            end
          end
        end

        def validate_by(by_section)
          raise_err('by is not an Array') unless by_section.is_a? Array
          raise_err('by is empty') if by_section.empty?
          by_section.each do |item|
            raise_err("by:#{item} is not a Hash") unless item.is_a? Hash
            raise_err('by is empty') if item.empty?
            item.each do |k, _v|
              raise_err('by section must only contain [username,group]') unless %w[username group].include?(k)
            end
            %w[username group].each do |type|
              raise_err("by:#{type} is not a String or an Array") if item.key?(type) && !item[type].is_a?(String) && !item[type].is_a?(Array)
            end
          end
        end
      end

      def validate_acl(hash)
        rv = RundeckValidator.new
        rv.validate_description(hash['description'])
        rv.validate_context(hash['context'])
        rv.validate_for(hash['for'], hash['context'])
        rv.validate_by(hash['by'])
      end
      module_function :validate_acl
    end
  end
end
