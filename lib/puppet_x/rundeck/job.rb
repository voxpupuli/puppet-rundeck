require 'rest_client'
require 'xml'

module PuppetX
module Rundeck

  class Job
    attr_reader :resource

    def initialize(resource)

      @resource = resource

      default_token = ''
      File.open('/etc/rundeck/tokens.properties') do |file|
        file.each_line do |line|
          if line.start_with?('puppet')
            default_token = line.split('=')[1]
          end
        end
      end

      if @resource[:api_token].eql?('')
        api_token = default_token
      else
        apt_token = @resource[:api_token]
      end

      @headers = {:content_type => 'x-www-form-urlencoded', 'X-Rundeck-Auth-Token' => api_token }
    end

    def create(job_data)
      params = { :xmlBatch => job_data, :format => 'xml', :dupeOption => 'update' }

      begin
        RestClient.post "#{resource[:base_url]}/api/12/jobs/import", params, @headers
      rescue => e
        #p e.response
      end
    end

    def read(project, id=nil)
      begin
        if id
          job = RestClient.get "#{resource[:base_url]}/api/12/job/#{id}", @headers
          xml_doc = XML::Parser.string(job, :encoding => XML::Encoding::ISO_8859_1).parse
        else
          job = RestClient.get "#{resource[:base_url]}/api/12/project/#{project}/jobs", @headers
          xml_doc = XML::Parser.string(job, :encoding => XML::Encoding::ISO_8859_1).parse
        end
      rescue => e
        #p e.response
      end

    end

    def update(job_data)
      create(job_data)
    end

    def delete(id)
      RestClient.delete "#{resource[:base_url]}/api/12/job/#{id}"
    end

  end

end
end
