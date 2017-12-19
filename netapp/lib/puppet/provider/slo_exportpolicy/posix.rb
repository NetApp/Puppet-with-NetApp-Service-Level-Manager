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

Puppet::Type.type(:slo_exportpolicy).provide(:posix,
                                          :parent => Puppet::Provider::Netapp ) do

    desc "Manage Netapp API-S SLO exportpolicy creation, modification and deletion."
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
        $ro_hosts = resource[:ro_hosts]
        $rw_hosts = resource[:rw_hosts]
        $root = resource[:root]
        $security_type = resource[:security_type]
        $key = resource[:key]
    end
#============================CREATE====================================#
    def create
        if ((defined? $security_type) && (!( ($security_type.eql? "kerberos5i")  ||   ($security_type.eql? "ntlm")  ||   ($security_type.eql? "kerberos5p")  ||   ($security_type.eql? "sys")  ||   ($security_type.eql? "kerberos5")  )))
            Puppet.debug "Illegal value provided for parameter security_type Value given: "+$security_type.to_s
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

        apiUri = '/api/1.0/slo/export-policies'


        @payload = {}
        if !($name.to_s.empty?)
            @payload[:name] = $name
        end
        if !($storage_vm_key.to_s.empty?)
            @payload[:storage_vm_key] = $storage_vm_key
        end
        if !($ro_hosts.to_s.empty?)
            @payload[:ro_hosts] = $ro_hosts
        end
        if !($rw_hosts.to_s.empty?)
            @payload[:rw_hosts] = $rw_hosts
        end
        if !($root.to_s.empty?)
            @payload[:root] = $root
        end
        if !($security_type.to_s.empty?)
            @payload[:security_type] = $security_type
        end
        resourceType = "exportpolicy"

        if(transport.http_post_request(apiUri , @payload.to_json , resourceType))
            puts "#{resourceType} : #{resource[:name]} successfully created"
        else
            puts " #{resourceType} : #{resource[:name]} creation failed"
        end
    end # end of create
#================MODIFY=====================#
    def modify
        debug("#{self.class}::modify")

        if ((defined? $security_type) && (!( ($security_type.eql? "kerberos5i")  ||   ($security_type.eql? "ntlm")  ||   ($security_type.eql? "kerberos5p")  ||   ($security_type.eql? "sys")  ||   ($security_type.eql? "kerberos5")  )))
            Puppet.debug "Illegal value provided for parameter security_type Value given: "+$security_type.to_s
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
            resourceType = "export-policies"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/export-policies', resourceType, uriAttributeMap3)
        end
        apiUri = '/api/1.0/slo/export-policies/'+$key



        @payload = {}
        if !($ro_hosts.to_s.empty?)
            @payload[:ro_hosts] = $ro_hosts
        end
        if !($rw_hosts.to_s.empty?)
            @payload[:rw_hosts] = $rw_hosts
        end
        if !($root.to_s.empty?)
            @payload[:root] = $root
        end
        if !($security_type.to_s.empty?)
            @payload[:security_type] = $security_type
        end
        resourceType = "exportpolicy"

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
            resourceType = "export-policies"
            $key = self.retrieveKeyOfObjectType('/api/1.0/slo/export-policies', resourceType, uriAttributeMap3)

        end


        apiUri = '/api/1.0/slo/export-policies/'+$key
        resourceType = "exportpolicy"

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
        resourceType = "export-policies"
        resourceTypeSingular = "exportpolicy"
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
            resourceType = "export-policies"
        $key = self.retrieveKeyOfObjectType('/api/1.0/slo/export-policies', resourceType, uriAttributeMap3)
        end
        parentResourceKey = ""
        parentResourceName = ""
        if (resource[:ensure].to_s=="absent")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Deleting exportpolicy."
                return true
            else
                Puppet.debug "No such exportpolicy exists for deletion."
                return
            end
        elsif (resource[:ensure].to_s=="present")
            if(transport.exists(resourceType, $key, parentResourceKey,parentResourceName))
                Puppet.debug "Modifying exportpolicy."
                self.modify()
                return true
            else
                Puppet.debug "Creating exportpolicy."
                return false
            end
        end
    end # end of exists
end # end of do
