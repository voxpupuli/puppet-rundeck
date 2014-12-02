Puppet::Type.type(:rundeck_job).provide(:rest) do

  confine :true => begin
    begin
      require 'rest_client'
      require 'xml'
      require 'puppet_x/rundeck/job'
      true
    rescue LoadError
      false
    end
  end

  def rundeck_jobs
    PuppetX::Rundeck::Job.new(resource)
  end

  def rundeck_job
    rundeck_jobs.read(resource[:project], id)
  end

  def id
    job_list = rundeck_jobs.read(resource[:project])
    jobs = job_list.find("//*[name='#{resource[:name]}']")
    if !jobs.empty?
      jobs.first.find('@id').first.value
    else
      nil
    end
  end

  def exists?
    id != nil
  end

  def xml_fragment(root, collection)

    collection.each do |k,v|

      if k.start_with?('_')
        key = k.gsub('_','')

        root[key] = v
      else
        arg_node = XML::Node.new(k)

        if v.instance_of?(Hash)
          xml_fragment(arg_node, v)
        elsif v.instance_of?(Array)
          v.each do |entry|
            xml_fragment(arg_node, entry)
          end
        else
          arg_node << v
        end

        root << arg_node
      end

    end

  end

  def xml_data
    xml = XML::Document.new

    joblist = XML::Node.new('joblist')
    xml.root = joblist

    job = XML::Node.new('job')
    joblist << job

    if id
      ident = XML::Node.new('id')
      ident << id
      job << ident
    end

    loglevel = XML::Node.new('loglevel')
    loglevel << resource[:log_level]
    job << loglevel

    sequence = XML::Node.new('sequence')
    sequence['keepgoing'] = 'false'
    sequence['strategy'] = 'node-first'
    job << sequence

    resource[:commands].each do |command|
      cmd_node = XML::Node.new('command')

      xml_fragment(cmd_node, command)

      sequence << cmd_node
    end

    desc = XML::Node.new('description')
    desc << resource[:description]
    job << desc

    name = XML::Node.new('name')
    name << resource[:name]
    job << name

    context = XML::Node.new('context')
    proj = XML::Node.new('project')
    proj << resource[:project]
    context << proj
    job << context

    if resource[:threads]
      dispatch = XML::Node.new('dispatch')

      tc = XML::Node.new('threadcount')
      tc << resource[:threads]
      dispatch << tc

      kg = XML::Node.new('keepgoing')
      kg << resource[:keep_going]
      dispatch << kg

      ep = XML::Node.new('excludePrecedence')
      if resource[:node_precedence].eql?('exclude')
        ep << 'true'
      else
        ep << 'false'
      end
      dispatch << ep

      ra = XML::Node.new('rankAttribute')
      ra << resource[:rank_attribute]
      dispatch << ra

      ro = XML::Node.new('rankOrder')
      ro << resource[:rank_order]
      dispatch << ro

      job << dispatch
    end

    if id
      uuid = XML::Node.new('uuid')
      uuid << id
      job << uuid
    end

    if resource[:node_filter]
      filters = XML::Node.new('nodefilters')
      filter = XML::Node.new('filter')
      filter << resource[:node_filter]
      filters << filter
      job << filters
    end

    group = XML::Node.new('group')
    group << resource[:group]
    job << group

    Puppet.debug("LB: #{xml.to_s}")
    xml.to_s(:indent => true)
  end

  def create
    rundeck_jobs.create(xml_data)
  end

  def destroy
    rundeck_jobs.delete(id)
  end

  def group
    rundeck_job.find('//job/group').to_a[0].content
  end

  def group=(value)
    rundeck_jobs.update(xml_data)
  end

  def description
    rundeck_job.find('//job/description').to_a[0].content
  end

  def description=(value)
    rundeck_jobs.update(xml_data)
  end

  def log_level
    rundeck_job.find('//job/loglevel').to_a[0].content
  end

  def log_level=(value)
    rundeck_jobs.update(xml_data)
  end

  def commands
    command_array = []
    commands = rundeck_job.find('//job/sequence/command')

    commands.each do |element|
      element.children.to_a.each do |command|
        type = command.name
        cmd = command.content
        cmd.strip!

        if !cmd.empty?
          command_array.push({type => cmd})
        end
      end
    end

    command_array
  end

  def commands=(value)
    rundeck_jobs.update(xml_data)
  end

  def node_filter
    filter = rundeck_job.find('//job/nodefilters/filter').to_a[0].content
  end

  def node_filter=(value)
    rundeck_jobs.update(xml_data)
  end

  def threads

  end

  def threads=(value)
    rundeck_jobs.update(xml_data)
  end

  def rank_attribute

  end

  def rank_attribute=(value)
    rundeck_jobs.update(xml_data)
  end

  def rank_order

  end

  def rank_order=(value)
    rundeck_jobs.update(xml_data)
  end

  def keep_going

  end

  def keep_going=(value)
    rundeck_jobs.update(xml_data)
  end

  def node_precedence

  end

  def node_precedence=(value)
    rundeck_jobs.update(xml_data)
  end

end
