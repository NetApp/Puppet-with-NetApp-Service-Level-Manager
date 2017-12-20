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

Puppet::Type.type(:slo_lun).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO lun creation, modification and deletion."
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
        $size = resource[:size]
        $storage_vm_key = resource[:storage_vm_key]
        $storage_vm_name = resource[:storage_vm_name]
        $storage_vm_storage_system_name = resource[:storage_vm_storage_system_name]
        $storage_pool_key = resource[:storage_pool_key]
        $storage_pool_name = resource[:storage_pool_name]
        $storage_pool_storage_system_name = resource[:storage_pool_storage_system_name]
        $storage_service_level_key = resource[:storage_service_level_key]
        $storage_service_level_name = resource[:storage_service_level_name]
        $host_usage = resource[:host_usage]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        if ((defined? $host_usage) && (!( ($host_usage.eql? "xen")  ||   ($host_usage.eql? "windows_2008")  ||   ($host_usage.eql? "image")  ||   ($host_usage.eql? "esx:vmfs")  ||   ($host_usage.eql? "openvms")  ||   ($host_usage.eql? "windows")  ||   ($host_usage.eql? "solaris_efi")  ||   ($host_usage.eql? "aix")  ||   ($host_usage.eql? "linux")  ||   ($host_usage.eql? "hpux")  ||   ($host_usage.eql? "netware")  ||   ($host_usage.eql? "esx:vvol")  ||   ($host_usage.eql? "solaris")  ||   ($host_usage.eql? "windows_gpt")  ||   ($host_usage.eql? "hyper_v")  )))
            Puppet.debug "Illegal value provided for parameter host_usage Value given: "+$host_usage.to_s
        end

        #Retrieval of storage_vm_key
        if ((defined? $storage_vm_key) && !(($storage_vm_key.nil?) || ($storage_vm_key.empty?)))
            Puppet.debug('INFO: storage_vm_key already provided as a command parameter ' + $storage_vm_key)

        elsif (!($storage_vm_name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) )

            #Retrieve storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
            $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap2[:name] = $storage_vm_name
            resourceType = "storage-vms"
            $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

        end

        #Retrieval of storage_pool_key
        if ((defined? $storage_pool_key) && !(($storage_pool_key.nil?) || ($storage_pool_key.empty?)))
            Puppet.debug('INFO: storage_pool_key already provided as a command parameter ' + $storage_pool_key)

        elsif (!($storage_pool_name.to_s.empty?) && !($storage_pool_storage_system_name.to_s.empty?) )

            #Retrieve storage_pool_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_pool_storage_system_name
            resourceType = "storage-systems"
            $storage_pool_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve storage_pool_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $storage_pool_storage_system_key
            uriAttributeMap2[:name] = $storage_pool_name
            resourceType = "storage-pools"
            $storage_pool_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-pools', resourceType, uriAttributeMap2)

        end

        #Retrieval of storage_service_level_key
        if ((defined? $storage_service_level_key) && !(($storage_service_level_key.nil?) || ($storage_service_level_key.empty?)))
            Puppet.debug('INFO: storage_service_level_key already provided as a command parameter ' + $storage_service_level_key)

        elsif (!($storage_service_level_name.to_s.empty?) )

            #Retrieve storage_service_level_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_service_level_name
            resourceType = "storage-service-levels"
            $storage_service_level_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-service-levels', resourceType, uriAttributeMap1)

        end

        apiUri = '/api/1.0/slo/luns'


        @payload = {}
        if !($name.to_s.empty?)
            @payload[:name] = $name
        end
        if !($size.to_s.empty?)
            @payload[:size] = $size
        end
        if !($storage_vm_key.to_s.empty?)
            @payload[:storage_vm_key] = $storage_vm_key
        end
        if !($storage_pool_key.to_s.empty?)
            @payload[:storage_pool_key] = $storage_pool_key
        end
        if !($storage_service_level_key.to_s.empty?)
            @payload[:storage_service_level_key] = $storage_service_level_key
        end
        if !($host_usage.to_s.empty?)
            @payload[:host_usage] = $host_usage
        end
        resourceType = "lun"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts "#{resourceType} : #{resource[:name]} successfully created"
        else
            puts " #{resourceType} : #{resource[:name]} creation failed"
        end
    end # end of create
#================MODIFY=====================#
    def modify
        debug("#{self.class}::modify")

        if ((defined? $operational_state) && (!( ($operational_state.eql? "offline")  ||   ($operational_state.eql? "online")  ||   ($operational_state.eql? "degraded")  ||   ($operational_state.eql? "unknown")  )))
            Puppet.debug "Illegal value provided for parameter operational_state Value given: "+$operational_state.to_s
        end


        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_vm_name.to_s.empty?) && !($name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) )

            #Retrieve storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
            $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap2[:name] = $storage_vm_name
            resourceType = "storage-vms"
            $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $storage_vm_key
            uriAttributeMap3[:name] = $name
            resourceType = "luns"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap3)
        end
        apiUri = '/api/1.0/slo/luns/'+$key



        @payload = {}
        if !($size.to_s.empty?)
            @payload[:size] = $size
        end
        if !($operational_state.to_s.empty?)
            @payload[:operational_state] = $operational_state
        end
        resourceType = "lun"

        if(transport.http_put_request(apiUri , @payload.to_json , resourceType))
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
        end

    end # end of modify
#===============DELETE========================#
def destroy
        debug("#{self.class}::destroy")

        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_vm_name.to_s.empty?) && !($name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) )

            #Retrieve storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
            $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap2[:name] = $storage_vm_name
            resourceType = "storage-vms"
            $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $storage_vm_key
            uriAttributeMap3[:name] = $name
            resourceType = "luns"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap3)

        end


        apiUri = '/api/1.0/slo/luns/'+$key
        resourceType = "lun"

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
        resourceType = "luns"
        resourceTypeSingular = "lun"
        Puppet.debug "#{self.class}::exists?"
        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_vm_name.to_s.empty?) && !($name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) )
        #Retrieve storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
        $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)
            #Retrieve storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap2[:name] = $storage_vm_name
            resourceType = "storage-vms"
        $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)
            #Retrieve key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $storage_vm_key
            uriAttributeMap3[:name] = $name
            resourceType = "luns"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap3)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting lun."
                return true
            else
                Puppet.debug "No such lun exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying lun."
                self.modify()
                return true
            else
                Puppet.debug "Creating lun."
                return false
            end
        end
    end # end of exists
end # end of do
