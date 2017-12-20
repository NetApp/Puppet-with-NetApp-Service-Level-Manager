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

Puppet::Type.type(:slo_initiatorgroup).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO initiatorgroup creation, modification and deletion."
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
        $initiator_os_type = resource[:initiator_os_type]
        $initiators = resource[:initiators]
        $storage_vm_key = resource[:storage_vm_key]
        $storage_vm_name = resource[:storage_vm_name]
        $storage_vm_storage_system_name = resource[:storage_vm_storage_system_name]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        if ((defined? $initiator_os_type) && (!( ($initiator_os_type.eql? "xen")  ||   ($initiator_os_type.eql? "aix")  ||   ($initiator_os_type.eql? "default")  ||   ($initiator_os_type.eql? "linux")  ||   ($initiator_os_type.eql? "openvms")  ||   ($initiator_os_type.eql? "vmware")  ||   ($initiator_os_type.eql? "hpux")  ||   ($initiator_os_type.eql? "netware")  ||   ($initiator_os_type.eql? "windows")  ||   ($initiator_os_type.eql? "solaris")  ||   ($initiator_os_type.eql? "hyper_v")  )))
            Puppet.debug "Illegal value provided for parameter initiator_os_type Value given: "+$initiator_os_type.to_s
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

        apiUri = '/api/1.0/slo/initiator-groups'


        @payload = {}
        if !($name.to_s.empty?)
            @payload[:name] = $name
        end
        if !($initiator_os_type.to_s.empty?)
            @payload[:initiator_os_type] = $initiator_os_type
        end
        if !($initiators.to_s.empty?)
            @payload[:initiators] = $initiators
        end
        if !($storage_vm_key.to_s.empty?)
            @payload[:storage_vm_key] = $storage_vm_key
        end
        resourceType = "initiatorgroup"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts "#{resourceType} : #{resource[:name]} successfully created"
        else
            puts " #{resourceType} : #{resource[:name]} creation failed"
        end
    end # end of create
#================MODIFY=====================#
    def modify
        debug("#{self.class}::modify")

        if ((defined? $initiator_os_type) && (!( ($initiator_os_type.eql? "xen")  ||   ($initiator_os_type.eql? "aix")  ||   ($initiator_os_type.eql? "default")  ||   ($initiator_os_type.eql? "linux")  ||   ($initiator_os_type.eql? "openvms")  ||   ($initiator_os_type.eql? "vmware")  ||   ($initiator_os_type.eql? "hpux")  ||   ($initiator_os_type.eql? "netware")  ||   ($initiator_os_type.eql? "windows")  ||   ($initiator_os_type.eql? "solaris")  ||   ($initiator_os_type.eql? "hyper_v")  )))
            Puppet.debug "Illegal value provided for parameter initiator_os_type Value given: "+$initiator_os_type.to_s
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
            resourceType = "initiator-groups"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap3)
        end
        apiUri = '/api/1.0/slo/initiator-groups/'+$key



        @payload = {}
        if !($initiator_os_type.to_s.empty?)
            @payload[:initiator_os_type] = $initiator_os_type
        end
        if !($initiators.to_s.empty?)
            @payload[:initiators] = $initiators
        end
        resourceType = "initiatorgroup"

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
            resourceType = "initiator-groups"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap3)

        end


        apiUri = '/api/1.0/slo/initiator-groups/'+$key
        resourceType = "initiatorgroup"

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
        resourceType = "initiator-groups"
        resourceTypeSingular = "initiatorgroup"
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
            resourceType = "initiator-groups"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/initiator-groups', resourceType, uriAttributeMap3)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting initiatorgroup."
                return true
            else
                Puppet.debug "No such initiatorgroup exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying initiatorgroup."
                self.modify()
                return true
            else
                Puppet.debug "Creating initiatorgroup."
                return false
            end
        end
    end # end of exists
end # end of do
