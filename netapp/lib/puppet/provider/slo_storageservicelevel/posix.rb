#====================================================================
# Copyright (c) 2017 NetApp, Inc. All rights reserved.
# Specifications subject to change without notice.
#
# Disclaimer: This script is written as best effort and provides no
# warranty expressed or implied. Please contact the author(s) if you
# have questions about this script before running or modifying.
#====================================================================

require 'puppet/provider/netapp'
require 'puppet/util/network_device'

Puppet::Type.type(:slo_storageservicelevel).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO storageservicelevel creation, modification and deletion."
        confine :feature => :posix


    mk_resource_methods

    def self.instances
        Puppet.debug("#{self.class}::self.instances.")
    end

    def self.prefetch(resources)
        Puppet.debug("#{self.class}::self.prefetch.")
    end

    def initialize(value={})
        super(value)
        debug("#{self.class}::initialize")
    end

    def flush
        @property_hash[:ensure] == :present
    end
    def init
        $name = resource[:name]
        $description = resource[:description]
        $peak_latency = resource[:peak_latency]
        $peak_iops_per_tb = resource[:peak_iops_per_tb]
        $expected_iops_per_tb = resource[:expected_iops_per_tb]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        apiUri = '/api/1.0/slo/storage-service-levels'


        @payload = {}
        if !($name.to_s.empty?)
            @payload[:name] = $name
        end
        if !($description.to_s.empty?)
            @payload[:description] = $description
        end
        if !($peak_latency.to_s.empty?)
            @payload[:peak_latency] = $peak_latency
        end
        if !($peak_iops_per_tb.to_s.empty?)
            @payload[:peak_iops_per_tb] = $peak_iops_per_tb
        end
        if !($expected_iops_per_tb.to_s.empty?)
            @payload[:expected_iops_per_tb] = $expected_iops_per_tb
        end
        resourceType = "storageservicelevel"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts "#{resourceType} : #{resource[:name]} successfully created"
        else
            puts " #{resourceType} : #{resource[:name]} creation failed"
        end
    end # end of create
#================MODIFY=====================#
    def modify
        debug("#{self.class}::modify")


        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($name.to_s.empty?) )

            #Retrieve key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $name
            resourceType = "storage-service-levels"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-service-levels', resourceType, uriAttributeMap1)
        end
        apiUri = '/api/1.0/slo/storage-service-levels/'+$key



        @payload = {}
        if !($description.to_s.empty?)
            @payload[:description] = $description
        end
        if !($peak_latency.to_s.empty?)
            @payload[:peak_latency] = $peak_latency
        end
        if !($peak_iops_per_tb.to_s.empty?)
            @payload[:peak_iops_per_tb] = $peak_iops_per_tb
        end
        if !($expected_iops_per_tb.to_s.empty?)
            @payload[:expected_iops_per_tb] = $expected_iops_per_tb
        end
        resourceType = "storageservicelevel"

        if(transport.http_put_request(apiUri , @payload.to_json , resourceType))
            if(resource[:name] != null)
                puts "#{resourceType} : #{resource[:name]} successfully modified"
			else
			    puts " #{resourceType} successfully modified"
            end
            if(resource[:name] != null)
                puts "#{resourceType} : #{resource[:name]} successfully modified"
			else
			    puts " #{resourceType} successfully modified"
            end
        else
            if(resource[:name] != null)
                puts " #{resourceType} : #{resource[:name]} modification failed"
		    else
		        puts " #{resourceType} modification failed"
            end
            if(resource[:name] != null)
                puts " #{resourceType} : #{resource[:name]} modification failed"
		    else
		        puts " #{resourceType} modification failed"
            end
        end

    end # end of modify
#===============DELETE========================#
def destroy
        debug("#{self.class}::destroy")

        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($name.to_s.empty?) )

            #Retrieve key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $name
            resourceType = "storage-service-levels"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-service-levels', resourceType, uriAttributeMap1)

        end


        apiUri = '/api/1.0/slo/storage-service-levels/'+$key
        resourceType = "storageservicelevel"

        if(transport.http_delete_request(apiUri ,resourceType))
            if(resource[:name] != null)
                puts "#{resourceType} : #{resource[:name]} successfully deleted"
			else
			    puts " #{resourceType} successfully deleted"
			end
        else
            if(resource[:name] != null)
                puts " #{resourceType} : #{resource[:name]} deletion failed"
		    else
			    puts " #{resourceType} deletion failed"
		    end
        end

end # end of destroy

#========================Private Methods============================================#
    def retrieveKeyOfObjectType(resourceUri , resourceType , uriAttributeMap)

        if(resourceType == "cifs-share-acls")
            apiUri = "/api/1.0/slo/cifs-shares/"+uriAttributeMap[:cifs_share_key]+"/"+resourceType
            uriAttributeMap.delete(:cifs_share_key)
        elsif ($resourceTypePlural == "snapshots")
            apiUri = "/api/1.0/slo/file-shares/"+uriAttributeMap[:file_share_key]+"/"+resourceType
            uriAttributeMap.delete(:file_share_key)
        else
            apiUri = resourceUri
        end
        apiUri += '?'
        first = 1

        uriAttributeMap.each do |key, value|
            if (first == 0)
                apiUri += '&'
            end
            first = 0
            apiUri += key.to_s + '=' + value.to_s
        end
        key = transport.get_key(apiUri,resourceType)
        if(key)
            return key
        else
            return false
        end
    end # end of retrieveKeyOfObjectType

    def exists?
        self.init
        resourceType = "storage-service-levels"
        resourceTypeSingular = "storageservicelevel"
        Puppet.debug "#{self.class}::exists?"
        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($name.to_s.empty?) )
        #Retrieve key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $name
            resourceType = "storage-service-levels"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-service-levels', resourceType, uriAttributeMap1)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting storageservicelevel."
                return true
            else
                Puppet.debug "No such storageservicelevel exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying storageservicelevel."
                self.modify()
                return true
            else
                Puppet.debug "Creating storageservicelevel."
                return false
            end
        end
    end # end of exists
end # end of do
