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
    Puppet.debug("LB:")
    job_list = rundeck_jobs.read(resource[:project])
    #xml_doc.xpath("//*[name='#{resource[:name]}']")[0].xpath('@id')[0].value
    jobs = job_list.xpath("//*[name='#{resource[:name]}']")
    if !jobs.empty?
      #jobs[0].xpath('@id')[0].value
    else
      nil
    end
  end

  def exists?
    id != nil
  end

  def create
    Puppet.debug("LB: create")

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.joblist {
        xml.job {
          xml.loglevel resource[:log_level]
          xml.sequence('keepgoing'=>'false','strategy'=>'node-first') {
            resource[:commands].each do |command|
              xml.command {
                xml.exec command[1]
              }
            end
          }
          xml.description resource[:description]
          xml.name resource[:name]
          xml.context_ {
            xml.project resource[:project]
          }
        }
      }
    end

    Puppet.debug("LB: #{builder.to_xml}")
    rundeck_jobs.create(builder.to_xml)
  end

  def destroy

  end

  def project

  end

  def project=(value)

  end

  def commands

  end

  def commands=(value)

  end

  def group

  end

  def group=(value)

  end

  def description

  end

  def description=(value)

  end

  def loglevel

  end

  def loglevel=(value)

  end

  def nodefilters

  end

  def nodefilter=(value)

  end

end
