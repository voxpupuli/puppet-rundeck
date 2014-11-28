require 'rest_client'
require 'nokogiri'

module PuppetX
module Rundeck

  class Job
    attr_reader :resource

    def initialize(resource)
      @resource = resource
      @headers = {:content_type => 'x-www-form-urlencoded', 'X-Rundeck-Auth-Token' => 'hpGq8wZZaDCn51WtTIgCGUosjb8IsD4q'}
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
          xml_doc = Nokogiri::XML(job)
        else
          job = RestClient.get "#{resource[:base_url]}/api/12/project/#{project}/jobs", @headers
          xml_doc = Nokogiri::XML(job)
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
