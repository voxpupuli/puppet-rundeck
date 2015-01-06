require 'rest_client'
require 'xml'
require 'net/http'

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
            default_token = line.split('=')[1].gsub(/\s+/, '')
          end
        end
      end

      if @resource[:api_token].eql?('')
        api_token = default_token
      else
        apt_token = @resource[:api_token]
      end

      @headers = {'Content-Type' => 'x-www-form-urlencoded', 'X-Rundeck-Auth-Token' => api_token }
    end

    def create(job_data)
      params = { 'xmlBatch' => job_data, 'format' => 'xml', 'dupeOption' => 'update' }

      begin
        #RestClient.post "#{resource[:base_url]}/api/12/jobs/import", params, @headers

        url = "#{resource[:base_url]}/api/12/jobs/import"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :TLSv1
        http.ciphers = ['RC4-SHA']
        req = Net::HTTP::Post.new(uri.request_uri, @headers)
        req.set_form_data(params)
        res = http.request(req)
      rescue Exception => e
        raise Puppet::Error, "Could not create rundeck job: #{e}", e.backtrace
      end
    end

    def read(project, id=nil)
      begin
        if id
          url = "#{resource[:base_url]}/api/12/job/#{id}"
        else
          url = "#{resource[:base_url]}/api/12/project/#{project}/jobs"
        end
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :TLSv1
        http.ciphers = ['RC4-SHA']
        resp = http.get(uri.request_uri, @headers)
        job = resp.body
        xml_doc = XML::Parser.string(job, :encoding => XML::Encoding::ISO_8859_1).parse
      rescue Exception => e
        raise Puppet::Error, "Could not read rundeck job (#{id}): #{e} - #{resource[:base_url]} - #{@headers}", e.backtrace
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
