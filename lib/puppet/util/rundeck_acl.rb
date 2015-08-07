module Puppet::Util::RundeckACL
  
  class RundeckValidator

    def raise_err(msg)
      raise(Puppet::ParseError, "The policy is invalid - #{msg}")
    end

    def validate_description(description)
      if !description.is_a? String
        raise_err('description is not a String')
      end
    end

    def validate_context(context)
      if !context.is_a? Hash
        raise_err('context is not a Hash')
      elsif context.empty?
        raise_err('context is empty')
      else
        if context.keys.length != 1
          raise_err('context can only contain project or application')
        else
          type = context.keys[0]
          
          case type
          when 'project', 'application'
            if !context[type].is_a? String
              raise_err("context:#{type} is not a String")
            end
          else
            raise_err("context can only be project or application")
          end

        end
      end
    end

    def validate_rule_action(type, type_section, scope)
      action_found = false
      actions = []
      property = ''
      value = ''

      if type_section.empty?
        raise_err("for:#{type} is empty")
      end
      type_section.each do |e|
        if !e.is_a? Hash
          raise_err("for:#{type} entry is not a Hash")
        end
      end

      type_section.each do |e|
        e.each do |k,v|
          if k.eql?('allow') or k.eql?('deny')
            action_found = true
            actions = v
          elsif ['match','equals','contains'].include?(k)
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
            else
              #
            end
          end
        end

        if !action_found
          raise_err("for:#{type} does not contain a rule action of [allow,deny]")
        else
          if scope.eql?('project')
            if property.to_s != '' or type.eql?('adhoc') or type.eql?('node')
              validate_proj_actions(type, actions, property, value)
            end
          elsif scope.eql?('application')
            validate_app_actions(type, actions, property, value) 
          end
        end
      end
      
    end

    def validate_proj_actions(type, actions, property, value='')
      project_actions = {
        'resource' => {
          'job'   => ['create','delete'],
          'node'  => ['read','create','update','refresh'],
          'event' => ['read','create']
         },
        'adhoc' => ['read','run','runAs','kill','killAs'],
        'job' => {
          'name' => ['read','update','delete','run','runAs','kill','killAs','create'],
          'group' => ['read','update','delete','run','runAs','kill','killAs','create']
        },
        'node' => ['read','run']
      }

      case type
      when 'resource'
        case property
        when 'job', 'node', 'event'
          actions.each do |action|
            if !project_actions[type][property].include?(action)
              raise_err("for:resource kind:#{property} can only contain actions #{project_actions[type][property]}")
            end
          end
        else
          #
        end
      when 'adhoc', 'node'
       actions.each do |action|
        if !project_actions[type].include?(action)
          raise_err("for:#{type} can only contain actions #{project_actions[type]}") 
        end
       end
      when 'job'
        case property
        when 'name','group'
          actions.each do |action|
            if !project_actions[type][property].include?(action)
              raise_err("for:job #{property}:#{value} can only contain actions #{project_actions[type][property]}")
            end
          end
        else
          raise_err("#{property} is not a valid property for the job scope")
        end
      else
        #
      end
    end

    def validate_app_actions(type, actions, property, value='')
      app_actions = {
        'resource' => {
          'project' => ['create'],
          'system'  => ['read'],
          'user'    => ['admin'],
          'job'     => ['admin']
        },
        'project' => {
          'name' => ['read','configure','delete','import','export','delete_execution','admin']
        },
        'storage' => {
          'name' => ['create','update','read','delete'],
          'path' => ['create','update','read','delete']
        }
      }

      case type
      when 'resource'
        case property
        when 'project', 'system','user','job'
          actions.each do |action|
            if !app_actions[type][property].include?(action)
              raise_err("for:resource kind:#{property} can only contain actions #{app_actions[type][property]}")
            end
          end
        else
        end
      when 'project'
        if property.eql?('name')
          actions.each do |action|
            if !app_actions[type][property].include?(action)
              raise_err("for:project #{property} can only contain actions #{app_actions[type][property]}")
            end
          end
        end
      when 'storage'
        p "LB: #{type}"
        p "LB: #{property}"
        case property
        when 'name', 'path'
          actions.each do |action|
            if !app_actions[type][property].include?(action)
              raise_err("for:storage #{property} can only contain actions #{app_actions[type][property]}")
            end
          end
        else
        end
      else
        #
      end
    end

    def validate_matching(type, type_section)
      matching_found = false
      if type_section.empty?
        raise_err("for:#{type} is empty")
      end
      type_section.each do |e|
        if e.is_a? Hash
          e.each do |k,v|
            if k.eql?('match') or k.eql?('equals') or k.eql?('contains')
              matching_found = true
            end
          end
        else
          raise_err("for:#{type} entry is not a Hash")
        end
      end
      if !matching_found
        raise_err("for:#{type} does not contain a matching statement of [match,equals,contains]")
      end
    end

    def validate_for(for_section, context)
      if !for_section.is_a? Hash
        raise_err("for is not a Hash")
      elsif for_section.empty?
        raise_err("for is empty")          
      else
        scope = context.keys[0]

        if scope.eql?('project')
          resource_types = ['job','node','adhoc','project','resource']
        elsif scope.eql?('application')
          resource_types = ['resource','project','storage']
        else
          raise_err("unknown scope: #{scope}")
        end

        for_section.each do |k,v|
          if !resource_types.include?(k)
            raise_err("for section must only contain #{resource_types.inspect.gsub!('"',"'")}")
          end
        end
           
        resource_types.each do |type|
          if for_section.has_key?(type)
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
    end

    def validate_by(by_section)
      if !by_section.is_a? Array
       raise_err("by is not an Array")
      elsif by_section.empty?
       raise_err("by is empty")
      else

        by_section.each do |item|
          if !item.is_a? Hash
            raise_err("by:#{item} is not a Hash")
          elsif item.empty?
            raise_err("by is empty")
          else
            
          item.each do |k,v|
            if !['username','group'].include?(k)
              raise_err("by section must only contain [username,group]")
            end
          end

            ['username','group'].each do |type|
              if item.has_key?(type)
                if !item[type].is_a? String and !item[type].is_a? Array
                  raise_err("by:#{type} is not a String or an Array")
                end
              end
            end
          end
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