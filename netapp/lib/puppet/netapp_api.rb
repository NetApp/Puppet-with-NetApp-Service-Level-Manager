#====================================================================
# Copyright (c) 2017 NetApp, Inc. All rights reserved.
# Specifications subject to change without notice.
#
# Disclaimer: This script is written as best effort and provides no
# warranty expressed or implied. Please contact the author(s) if you
# have questions about this script before running or modifying.
#====================================================================

require 'net/http'
require 'uri'
require 'json'
require 'openssl'
require 'rubygems'

class NetAppApi
    VERSION = "1.0"
    attr_accessor :url
    @debug = true

    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

    def initialize(url)
        debug("#{self.class}::initialize -> #{url}")
        @url = URI.parse(url)
    end

    def method_missing(name, *args)
#        debug("#{self.class}::method_missing -> #{name}")
    end

    def http_post_request(url_path,payload,resourceType)
        debug("#{self.class}::http_post_request")
        Puppet.debug "PAYLOAD:"+payload
        post_url="https://"+@url.host+":"+@url.port.to_s+url_path
        uri = URI(post_url)
        Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == 'https') do |http|
            request     = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
            request.basic_auth(@url.user,@url.password)
            request.body= payload.to_s
            response    = http.request request # Net::HTTPResponse object
            debug "response get from api in post_req:"+response.body
            job_key     = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("key")
            Puppet.debug resourceType+" creation job_key:"+job_key
            sleep(10)
            
           return self.get_job_status(job_key)
        end
    end
    class JSONRPCError < RuntimeError; end

  def http_put_request(url_path,payload,resourceType)
        debug("#{self.class}::http_put_request")
        put_url="https://"+@url.host+":"+@url.port.to_s+url_path
        uri = URI(put_url)
        Puppet.debug "PAYLOAD:"+payload
        Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == 'https') do |http|
            request     = Net::HTTP::Put.new(uri, initheader = {'Content-Type' =>'application/json'})
            request.basic_auth(@url.user,@url.password)
            request.body= payload.to_s
            response    = http.request request # Net::HTTPResponse object
            Puppet.debug "response get from api in put_req:"+response.body
            job_key     = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("key")
            Puppet.debug resourceType+" modification job_key:"+job_key
            sleep(10)
            return self.get_job_status(job_key)
        end
    end


    def http_get_request(url_query)
        debug("#{self.class}::http_get_request")
        uri=URI(url_query)
        Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == 'https') do |http|
            request     = Net::HTTP::Get.new uri
            request.basic_auth(@url.user,@url.password)
            response    = http.request request # Net::HTTPResponse object
            Puppet.debug "http_get_response URI :"+uri.to_s
            debug "response in http_get_request from api:"+response.to_s
            return response
        end
    end


   def http_delete_request(url_path,resourceType)
        debug("#{self.class}::http_delete_request")
        delete_url="https://"+@url.host+":"+@url.port.to_s+url_path
        uri=URI(delete_url)
        Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == 'https') do |http|
            request     = Net::HTTP::Delete.new uri
            request.basic_auth(@url.user,@url.password)
            response    = http.request request # Net::HTTPResponse object
            Puppet.debug  "http_delete_response URI:"+uri.to_s
            Puppet.debug "response get from api in del_req:"+response.body
            job_status     = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("status")
            job_key     = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("key")
            sleep(10)
            return self.get_job_status(job_key)
        end # end of delete resource
    end

################ HELPING FUNCTION #############

    def get_job_status(job_key)
        url         = "https://"+@url.host+":"+@url.port.to_s+"/api/1.0/jobs/"
        uri         = URI("#{url}#{job_key}")
        response    = http_get_request(uri)
        job_status  = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("status")
        if((job_status == "COMPLETED") || (job_status == "FAILED"))
            Puppet.debug "JOB-STATUS: "+job_status
            if(job_status == "COMPLETED")
                return true
            else
                return false
            end
        else
            Puppet.debug "Waiting for job to finish"
            sleep(5)
            self.get_job_status(job_key)
        end
    end

    def get_key(url_query, resourceType)
        url = "https://"+@url.host+":"+@url.port.to_s+url_query
        uri=URI(url)
        response    = self.http_get_request(uri.to_s)
        Puppet.debug "DEBUG in key response:"+response.body
        begin
            job_key = JSON.parse(response.body).fetch("result").fetch("records")[0].fetch("key")
            Puppet.debug "job_key: "+job_key
        rescue
            Puppet.debug"Catching Exception: such resource name does not exist"
            return false
        end
        return job_key
        
    end

    def exists(resourceType,resourceKey,parentResourceKey,parentResourceName)
        if ((parentResourceName.empty?) && (parentResourceKey.empty?))
            if ( resourceKey.to_s!= "false") 
                job_key = resourceKey
                job_key_query = "/api/1.0/slo/"+resourceType+"?key="+resourceKey
            else
                job_key = false
            end
        else
            job_key_query = "/api/1.0/slo/"+parentResourceName+"/"+parentResourceKey+"/"+resourceType
        end

        if (job_key)
            Puppet.debug"job_key_query :"+job_key_query 
            job_key = self.get_key(job_key_query, resourceType)
        end
        
        if(job_key)
            return true
        else
            return false
        end 
   end
end