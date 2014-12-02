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

    if id
      uuid = XML::Node.new('uuid')
      uuid << id
      job << uuid
    end

    group = XML::Node.new('group')
    group << resource[:group]
    job << group

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

  def nodefilters

  end

  def nodefilter=(value)

  end

end
