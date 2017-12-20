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

Puppet::Type.type(:slo_cifsshareacl).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO cifsshareacl creation, modification and deletion."
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
        $user_or_group = resource[:user_or_group]
        $permission = resource[:permission]
        $storage_vm_key = resource[:storage_vm_key]
        $storage_vm_name = resource[:storage_vm_name]
        $storage_vm_storage_system_name = resource[:storage_vm_storage_system_name]
        $cifs_share_key = resource[:cifs_share_key]
        $cifs_share_file_share_name = resource[:cifs_share_file_share_name]
        $cifs_share_file_share_storage_vm_name = resource[:cifs_share_file_share_storage_vm_name]
        $cifs_share_file_share_storage_vm_storage_system_name = resource[:cifs_share_file_share_storage_vm_storage_system_name]
        $cifs_share_name = resource[:cifs_share_name]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        if ((defined? $permission) && (!( ($permission.eql? "not_mapped")  ||   ($permission.eql? "full_control")  ||   ($permission.eql? "no_access")  ||   ($permission.eql? "read")  ||   ($permission.eql? "change")  )))
            Puppet.debug "Illegal value provided for parameter permission Value given: "+$permission.to_s
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

        #Retrieval of cifs_share_key
        if ((defined? $cifs_share_key) && !(($cifs_share_key.nil?) || ($cifs_share_key.empty?)))
            Puppet.debug('INFO: cifs_share_key already provided as a command parameter ' + $cifs_share_key)

        elsif (!($cifs_share_file_share_storage_vm_name.to_s.empty?) && !($cifs_share_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_storage_system_name.to_s.empty?) && !($cifs_share_file_share_name.to_s.empty?) )

            #Retrieve cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $cifs_share_file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $cifs_share_file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve cifs_share_file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $cifs_share_file_share_storage_vm_name
            resourceType = "storage-vms"
            $cifs_share_file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve cifs_share_file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $cifs_share_file_share_storage_vm_key
            uriAttributeMap3[:name] = $cifs_share_file_share_name
            resourceType = "file-shares"
            $cifs_share_file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)

            #Retrieve cifs_share_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $cifs_share_name
            uriAttributeMap4[:file_share_key] = $cifs_share_file_share_key
            resourceType = "cifs-shares"
            $cifs_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap4)

        end

        baseUri = '/api/1.0/slo/cifs-shares/'
        resourceKey = $cifs_share_key+'/'
        subResourceName = 'cifs-share-acls'
        apiUri = baseUri+resourceKey+subResourceName


        @payload = {}
        if !($user_or_group.to_s.empty?)
            @payload[:user_or_group] = $user_or_group
        end
        if !($permission.to_s.empty?)
            @payload[:permission] = $permission
        end
        if !($storage_vm_key.to_s.empty?)
            @payload[:storage_vm_key] = $storage_vm_key
        end
        if !($cifs_share_key.to_s.empty?)
            @payload[:cifs_share_key] = $cifs_share_key
        end
        resourceType = "cifsshareacl"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts " #{resourceType} successfully created"
        else
           puts " #{resourceType} creation failed"
        end
    end # end of create
#================MODIFY=====================#
    def modify
        debug("#{self.class}::modify")

        if ((defined? $permission) && (!( ($permission.eql? "not_mapped")  ||   ($permission.eql? "full_control")  ||   ($permission.eql? "no_access")  ||   ($permission.eql? "read")  ||   ($permission.eql? "change")  )))
            Puppet.debug "Illegal value provided for parameter permission Value given: "+$permission.to_s
        end


        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_platform_type.to_s.empty?) && !($storage_vm_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) && !($cifs_share_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_storage_system_name.to_s.empty?) && !($user_or_group.to_s.empty?) && !($cifs_share_file_share_name.to_s.empty?) )

            #Retrieve cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $cifs_share_file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $cifs_share_file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve cifs_share_file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $cifs_share_file_share_storage_vm_name
            resourceType = "storage-vms"
            $cifs_share_file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve cifs_share_file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $cifs_share_file_share_storage_vm_key
            uriAttributeMap3[:name] = $cifs_share_file_share_name
            resourceType = "file-shares"
            $cifs_share_file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)

            #Retrieve storage_vm_storage_system_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
            $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap4)

            #Retrieve storage_vm_key
            uriAttributeMap5 = {}
            uriAttributeMap5[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap5[:name] = $storage_vm_name
            resourceType = "storage-vms"
            $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap5)

            #Retrieve cifs_share_key
            uriAttributeMap6 = {}
            uriAttributeMap6[:name] = $cifs_share_name
            uriAttributeMap6[:file_share_key] = $cifs_share_file_share_key
            resourceType = "cifs-shares"
            $cifs_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap6)

            #Retrieve key
            uriAttributeMap7 = {}
            uriAttributeMap7[:storage_vm_key] = $storage_vm_key
            uriAttributeMap7[:storage_platform_type] = $storage_platform_type
            uriAttributeMap7[:cifs_share_key] = $cifs_share_key
            uriAttributeMap7[:user_or_group] = $user_or_group
            resourceType = "cifs-share-acls"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-share-acls', resourceType, uriAttributeMap7)
        end
        baseUri = '/api/1.0/slo/cifs-shares/'
        resourceKey = $cifs_share_key+'/'
        subResourceName = cifs-share-acls
        apiUri = baseUri+resourceKey+subResourceName+$key



        @payload = {}
        if !($permission.to_s.empty?)
            @payload[:permission] = $permission
        end
        resourceType = "cifsshareacl"

        if(transport.http_put_request(apiUri , @payload.to_json , resourceType))
            puts " #{resourceType} successfully modified"
        else
            puts " #{resourceType} modification failed"
        end

    end # end of modify
#===============DELETE========================#
def destroy
        debug("#{self.class}::destroy")

        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_platform_type.to_s.empty?) && !($storage_vm_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) && !($cifs_share_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_storage_system_name.to_s.empty?) && !($user_or_group.to_s.empty?) && !($cifs_share_file_share_name.to_s.empty?) )

            #Retrieve cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $cifs_share_file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
            $cifs_share_file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)

            #Retrieve cifs_share_file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $cifs_share_file_share_storage_vm_name
            resourceType = "storage-vms"
            $cifs_share_file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)

            #Retrieve cifs_share_file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $cifs_share_file_share_storage_vm_key
            uriAttributeMap3[:name] = $cifs_share_file_share_name
            resourceType = "file-shares"
            $cifs_share_file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)

            #Retrieve storage_vm_storage_system_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
            $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap4)

            #Retrieve storage_vm_key
            uriAttributeMap5 = {}
            uriAttributeMap5[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap5[:name] = $storage_vm_name
            resourceType = "storage-vms"
            $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap5)

            #Retrieve cifs_share_key
            uriAttributeMap6 = {}
            uriAttributeMap6[:name] = $cifs_share_name
            uriAttributeMap6[:file_share_key] = $cifs_share_file_share_key
            resourceType = "cifs-shares"
            $cifs_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap6)

            #Retrieve key
            uriAttributeMap7 = {}
            uriAttributeMap7[:storage_vm_key] = $storage_vm_key
            uriAttributeMap7[:storage_platform_type] = $storage_platform_type
            uriAttributeMap7[:cifs_share_key] = $cifs_share_key
            uriAttributeMap7[:user_or_group] = $user_or_group
            resourceType = "cifs-share-acls"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-share-acls', resourceType, uriAttributeMap7)

        end


        baseUri = '/api/1.0/slo/cifs-shares/'
        resourceKey = $cifs_share_key+'/'
        subResourceName = cifs-share-acls
        apiUri = baseUri+resourceKey+subResourceName+$key
        resourceType = "cifsshareacl"

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
        resourceType = "cifs-share-acls"
        resourceTypeSingular = "cifsshareacl"
        Puppet.debug "#{self.class}::exists?"
        #Retrieval of key
        if ((defined? $key) && !(($key.nil?) || ($key.empty?)))
            Puppet.debug('INFO: key already provided as a command parameter ' + $key)

        elsif (!($storage_platform_type.to_s.empty?) && !($storage_vm_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_name.to_s.empty?) && !($storage_vm_storage_system_name.to_s.empty?) && !($cifs_share_name.to_s.empty?) && !($cifs_share_file_share_storage_vm_storage_system_name.to_s.empty?) && !($user_or_group.to_s.empty?) && !($cifs_share_file_share_name.to_s.empty?) )
        #Retrieve cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap1 = {}
            uriAttributeMap1[:name] = $cifs_share_file_share_storage_vm_storage_system_name
            resourceType = "storage-systems"
        $cifs_share_file_share_storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap1)
            #Retrieve cifs_share_file_share_storage_vm_key
            uriAttributeMap2 = {}
            uriAttributeMap2[:storage_system_key] = $cifs_share_file_share_storage_vm_storage_system_key
            uriAttributeMap2[:name] = $cifs_share_file_share_storage_vm_name
            resourceType = "storage-vms"
        $cifs_share_file_share_storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap2)
            #Retrieve cifs_share_file_share_key
            uriAttributeMap3 = {}
            uriAttributeMap3[:storage_vm_key] = $cifs_share_file_share_storage_vm_key
            uriAttributeMap3[:name] = $cifs_share_file_share_name
            resourceType = "file-shares"
        $cifs_share_file_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/file-shares', resourceType, uriAttributeMap3)
            #Retrieve storage_vm_storage_system_key
            uriAttributeMap4 = {}
            uriAttributeMap4[:name] = $storage_vm_storage_system_name
            resourceType = "storage-systems"
        $storage_vm_storage_system_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-systems', resourceType, uriAttributeMap4)
            #Retrieve storage_vm_key
            uriAttributeMap5 = {}
            uriAttributeMap5[:storage_system_key] = $storage_vm_storage_system_key
            uriAttributeMap5[:name] = $storage_vm_name
            resourceType = "storage-vms"
        $storage_vm_key = self.retrieveKeyOfObjectType('/api/1.0/slo/storage-vms', resourceType, uriAttributeMap5)
            #Retrieve cifs_share_key
            uriAttributeMap6 = {}
            uriAttributeMap6[:name] = $cifs_share_name
            uriAttributeMap6[:file_share_key] = $cifs_share_file_share_key
            resourceType = "cifs-shares"
        $cifs_share_key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-shares', resourceType, uriAttributeMap6)
            #Retrieve key
            uriAttributeMap7 = {}
            uriAttributeMap7[:storage_vm_key] = $storage_vm_key
            uriAttributeMap7[:storage_platform_type] = $storage_platform_type
            uriAttributeMap7[:cifs_share_key] = $cifs_share_key
            uriAttributeMap7[:user_or_group] = $user_or_group
            resourceType = "cifs-share-acls"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/cifs-share-acls', resourceType, uriAttributeMap7)
        end
        parentResourceKey=$cifs_share_key
        parentResourceName=$cifs_share_name
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting cifsshareacl."
                return true
            else
                Puppet.debug "No such cifsshareacl exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying cifsshareacl."
                self.modify()
                return true
            else
                Puppet.debug "Creating cifsshareacl."
                return false
            end
        end
    end # end of exists
end # end of do
