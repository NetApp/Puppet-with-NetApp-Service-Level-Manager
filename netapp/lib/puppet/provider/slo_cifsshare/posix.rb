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

Puppet::Type.type(:slo_cifsshare).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO cifsshare creation, modification and deletion."
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
        $storage_vm_key = resource[:storage_vm_key]
        $storage_vm_name = resource[:storage_vm_name]
        $storage_vm_storage_system_name = resource[:storage_vm_storage_system_name]
        $file_share_key = resource[:file_share_key]
        $file_share_name = resource[:file_share_name]
        $file_share_storage_vm_name = resource[:file_share_storage_vm_name]
        $file_share_storage_vm_storage_system_name = resource[:file_share_storage_vm_storage_system_name]
        $directory = resource[:directory]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
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

        #Retrieval of file_share_key
        if ((defined? $file_share_key) && !(($file_share_key.nil?) || ($file_share_key.empty?)))
            Puppet.debug('INFO: file_share_key already provided as a command parameter ' + $file_share_key)

        elsif (!($file_share_storage_vm_name.to_s.empty?) && !($file_share_storage_vm_storage_system_name.to_s.empty?) && !($file_share_name.to_s.empty?) )

            #Retrieve file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $file_share_storage_vm_name
            resourceType = "storage-vms"
            $file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $file_share_storage_vm_key
            uriAttributeMap3[:name] = $file_share_name
            resourceType = "file-shares"
            $file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)

        end

        apiUri = '/api/1.0/slo/cifs-shares'


        @payload = {}
        if !($name.to_s.empty?)
            @payload[:name] = $name
        end
        if !($storage_vm_key.to_s.empty?)
            @payload[:storage_vm_key] = $storage_vm_key
        end
        if !($file_share_key.to_s.empty?)
            @payload[:file_share_key] = $file_share_key
        end
        if !($directory.to_s.empty?)
            @payload[:directory] = $directory
        end
        resourceType = "cifsshare"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts "#{resourceType} : #{resource[:name]} successfully created"
        else
            puts " #{resourceType} : #{resource[:name]} creation failed"
        end
    end # end of create
#===============DELETE========================#
def destroy
        debug("#{self.class}::destroy")

        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($file_share_storage_vm_name.to_s.empty?) && !($file_share_storage_vm_storage_system_name.to_s.empty?) && !($file_share_name.to_s.empty?) && !($name.to_s.empty?) )

            #Retrieve file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $file_share_storage_vm_name
            resourceType = "storage-vms"
            $file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $file_share_storage_vm_key
            uriAttributeMap3[:name] = $file_share_name
            resourceType = "file-shares"
            $file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)

            #Retrieve key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $name
            uriAttributeMap4[:file_share_key] = $file_share_key
            resourceType = "cifs-shares"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap4)

        end


        apiUri = '/api/1.0/slo/cifs-shares/'+$key
        resourceType = "cifsshare"

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
        resourceType = "cifs-shares"
        resourceTypeSingular = "cifsshare"
        Puppet.debug "#{self.class}::exists?"
        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($file_share_storage_vm_name.to_s.empty?) && !($file_share_storage_vm_storage_system_name.to_s.empty?) && !($file_share_name.to_s.empty?) && !($name.to_s.empty?) )
        #Retrieve file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
        $file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)
            #Retrieve file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $file_share_storage_vm_name
            resourceType = "storage-vms"
        $file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)
            #Retrieve file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $file_share_storage_vm_key
            uriAttributeMap3[:name] = $file_share_name
            resourceType = "file-shares"
        $file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)
            #Retrieve key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $name
            uriAttributeMap4[:file_share_key] = $file_share_key
            resourceType = "cifs-shares"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap4)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting cifsshare."
                return true
            else
                Puppet.debug "No such cifsshare exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying cifsshare."
                self.modify()
                return true
            else
                Puppet.debug "Creating cifsshare."
                return false
            end
        end
    end # end of exists
end # end of do
