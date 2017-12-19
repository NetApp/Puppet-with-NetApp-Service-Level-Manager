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

Puppet::Type.type(:slo_lunmap).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO lunmap creation, modification and deletion."
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
        $lun_key = resource[:lun_key]
        $lun_name = resource[:lun_name]
        $lun_storage_vm_name = resource[:lun_storage_vm_name]
        $lun_storage_vm_storage_system_name = resource[:lun_storage_vm_storage_system_name]
        $initiator_group_key = resource[:initiator_group_key]
        $initiator_group_name = resource[:initiator_group_name]
        $initiator_group_storage_vm_name = resource[:initiator_group_storage_vm_name]
        $initiator_group_storage_vm_storage_system_name = resource[:initiator_group_storage_vm_storage_system_name]
        $lun_id = resource[:lun_id]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        #Retrieval of initiator_group_key
        if ((defined? $initiator_group_key) && !(($initiator_group_key.nil?) || ($initiator_group_key.empty?)))
            Puppet.debug('INFO: initiator_group_key already provided as a command parameter ' + $initiator_group_key)

        elsif (!($initiator_group_storage_vm_name.to_s.empty?) && !($initiator_group_storage_vm_storage_system_name.to_s.empty?) && !($initiator_group_name.to_s.empty?) )

            #Retrieve initiator_group_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $initiator_group_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $initiator_group_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve initiator_group_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $initiator_group_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $initiator_group_storage_vm_name
            resourceType = "storage-vms"
            $initiator_group_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve initiator_group_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $initiator_group_storage_vm_key
            uriAttributeMap3[:name] = $initiator_group_name
            resourceType = "initiator-groups"
            $initiator_group_key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap3)

        end

        #Retrieval of lun_key
        if ((defined? $lun_key) && !(($lun_key.nil?) || ($lun_key.empty?)))
            Puppet.debug('INFO: lun_key already provided as a command parameter ' + $lun_key)

        elsif (!($lun_storage_vm_storage_system_name.to_s.empty?) && !($lun_storage_vm_name.to_s.empty?) && !($lun_name.to_s.empty?) )

            #Retrieve lun_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $lun_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $lun_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve lun_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $lun_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $lun_storage_vm_name
            resourceType = "storage-vms"
            $lun_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve lun_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $lun_storage_vm_key
            uriAttributeMap3[:name] = $lun_name
            resourceType = "luns"
            $lun_key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap3)

        end

        apiUri = '/api/1.0/slo/lun-maps'


        @payload = {}
        if !($lun_key.to_s.empty?)
            @payload[:lun_key] = $lun_key
        end
        if !($initiator_group_key.to_s.empty?)
            @payload[:initiator_group_key] = $initiator_group_key
        end
        if !($lun_id.to_s.empty?)
            @payload[:lun_id] = $lun_id
        end
        resourceType = "lunmap"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts " #{resourceType} successfully created"
        else
           puts " #{resourceType} creation failed"
        end
    end # end of create
#===============DELETE========================#
def destroy
        debug("#{self.class}::destroy")

        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($initiator_group_storage_vm_name.to_s.empty?) && !($initiator_group_storage_vm_storage_system_name.to_s.empty?) && !($lun_storage_vm_storage_system_name.to_s.empty?) && !($lun_storage_vm_name.to_s.empty?) && !($lun_name.to_s.empty?) && !($initiator_group_name.to_s.empty?) )

            #Retrieve initiator_group_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $initiator_group_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $initiator_group_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve lun_storage_vm_storage_system_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:name] = $lun_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $lun_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap2)

            #Retrieve initiator_group_storage_vm_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_system_key] = $initiator_group_storage_vm_storage_system_key
            uriAttributeMap3[:name] = $initiator_group_storage_vm_name
            resourceType = "storage-vms"
            $initiator_group_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap3)

            #Retrieve lun_storage_vm_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:storage_system_key] = $lun_storage_vm_storage_system_key
            uriAttributeMap4[:name] = $lun_storage_vm_name
            resourceType = "storage-vms"
            $lun_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap4)

            #Retrieve lun_key
            uriAttributeMap5 = {}
            uriAttributeMap5[:storage_vm_key] = $lun_storage_vm_key
            uriAttributeMap5[:name] = $lun_name
            resourceType = "luns"
            $lun_key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap5)

            #Retrieve initiator_group_key
            uriAttributeMap6 = {}
            uriAttributeMap6[:storage_vm_key] = $initiator_group_storage_vm_key
            uriAttributeMap6[:name] = $initiator_group_name
            resourceType = "initiator-groups"
            $initiator_group_key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap6)

            #Retrieve key
            uriAttributeMap7 = {}
            uriAttributeMap7[:initiator_group_key] = $initiator_group_key
            uriAttributeMap7[:lun_key] = $lun_key
            resourceType = "lun-maps"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/lun-maps', resourceType, uriAttributeMap7)

        end


        apiUri = '/api/1.0/slo/lun-maps/'+$key
        resourceType = "lunmap"

        if(transport.http_delete_request(apiUri ,resourceType))
                puts " #{resourceType} successfully deleted"
        else
               puts " #{resourceType} deletion failed"
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
        resourceType = "lun-maps"
        resourceTypeSingular = "lunmap"
        Puppet.debug "#{self.class}::exists?"
        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($initiator_group_storage_vm_name.to_s.empty?) && !($initiator_group_storage_vm_storage_system_name.to_s.empty?) && !($lun_storage_vm_storage_system_name.to_s.empty?) && !($lun_storage_vm_name.to_s.empty?) && !($lun_name.to_s.empty?) && !($initiator_group_name.to_s.empty?) )
        #Retrieve initiator_group_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $initiator_group_storage_vm_storage_system_name
            resourceType = "storage-systems"
        $initiator_group_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)
            #Retrieve lun_storage_vm_storage_system_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:name] = $lun_storage_vm_storage_system_name
            resourceType = "storage-systems"
        $lun_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap2)
            #Retrieve initiator_group_storage_vm_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_system_key] = $initiator_group_storage_vm_storage_system_key
            uriAttributeMap3[:name] = $initiator_group_storage_vm_name
            resourceType = "storage-vms"
        $initiator_group_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap3)
            #Retrieve lun_storage_vm_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:storage_system_key] = $lun_storage_vm_storage_system_key
            uriAttributeMap4[:name] = $lun_storage_vm_name
            resourceType = "storage-vms"
        $lun_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap4)
            #Retrieve lun_key
            uriAttributeMap5 = {}
            uriAttributeMap5[:storage_vm_key] = $lun_storage_vm_key
            uriAttributeMap5[:name] = $lun_name
            resourceType = "luns"
        $lun_key = self.retrieveKeyOfObjectType('/api/1.0/slo/luns', resourceType, uriAttributeMap5)
            #Retrieve initiator_group_key
            uriAttributeMap6 = {}
            uriAttributeMap6[:storage_vm_key] = $initiator_group_storage_vm_key
            uriAttributeMap6[:name] = $initiator_group_name
            resourceType = "initiator-groups"
        $initiator_group_key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap6)
            #Retrieve key
            uriAttributeMap7 = {}
            uriAttributeMap7[:initiator_group_key] = $initiator_group_key
            uriAttributeMap7[:lun_key] = $lun_key
            resourceType = "lun-maps"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/lun-maps', resourceType, uriAttributeMap7)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting lunmap."
                return true
            else
                Puppet.debug "No such lunmap exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying lunmap."
                self.modify()
                return true
            else
                Puppet.debug "Creating lunmap."
                return false
            end
        end
    end # end of exists
end # end of do
