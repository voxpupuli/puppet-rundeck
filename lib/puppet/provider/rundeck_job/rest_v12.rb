Puppet::Type.type(:rundeck_job).provide(:rest) do

  confine :true => begin
    begin
      require 'rest_client'
      require 'nokogiri'
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
    jobs = job_list.xpath("//*[name='#{resource[:name]}']")
    if !jobs.empty?
      jobs.first.xpath('@id').first.value
    else
      nil
    end
  end

  def exists?
    id != nil
  end

  def xml_data
    Puppet.debug("LB: here")
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.joblist {
        xml.job {
          xml.id id if id
          xml.loglevel resource[:log_level]
          xml.sequence('keepgoing'=>'false','strategy'=>'node-first') {
            resource[:commands].each do |command|
              xml.command {
                type = command.to_a[0][0]
                cmd = command.to_a[0][1]
                if type.eql?('exec')
                  xml.exec_ cmd
                end
              }
            end
          }
          xml.description resource[:description]
          xml.name resource[:name]
          xml.context_ {
            xml.project resource[:project]
          }
          xml.group resource[:group]
        }
      }
    end

    Puppet.debug("LB: #{builder.to_xml}")
    builder.to_xml
  end

  def create
    rundeck_jobs.create(xml_data)
  end

  def destroy
    rundeck_jobs.delete(id)
  end

  def group
    rundeck_job.xpath('//job/group').text
  end

  def group=(value)
    rundeck_jobs.update(xml_data)
  end

  def description
    rundeck_job.xpath('//job/description').text
  end

  def description=(value)
    rundeck_jobs.update(xml_data)
  end

  def log_level
    rundeck_job.xpath('//job/loglevel').text
  end

  def log_level=(value)
    rundeck_jobs.update(xml_data)
  end

  def commands
    command_array = []
    commands = rundeck_job.xpath('//job/sequence/command')

    commands.each do |element|
      element.children.to_a.each do |command|
        type = command.name
        cmd = command.text
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
