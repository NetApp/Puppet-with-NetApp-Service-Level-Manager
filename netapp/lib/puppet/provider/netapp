#====================================================================
# Copyright (c) 2017 NetApp, Inc. All rights reserved.
# Specifications subject to change without notice.
#
# Disclaimer: This script is written as best effort and provides no
# warranty expressed or implied. Please contact the author(s) if you
# have questions about this script before running or modifying.
#====================================================================

require 'puppet/provider'
require 'puppet/util/network_device'
require 'puppet/util/network_device/netapp/device'

class Puppet::Provider::Netapp < Puppet::Provider

    def self.transport(args=nil)
        @device ||= Puppet::Util::NetworkDevice.current
        if not @device and Facter.value(:url)
            Puppet.debug "NetworkDevice::NetApp: connecting via facter url."
            @device ||= Puppet::Util::NetworkDevice::Netapp::Device.new(Facter.value(:url))
        end
        @tranport = @device.transport
    end

    def transport(*args)
        ## this calls the class instance of self.transport instead of the object
        # instance which causes an infinite loop.
        self.class.transport(args)
#        debug("#{self.class}::transport")
    end

    def self.method_missing(name, args)
	Puppet.debug"DEBUG in netapp.rb self method_missing"
#        debug("#{self.class}::method_missing") 
    end

    def method_missing(name, *args)
        self.class.method_missing(name, args)
        Puppet.debug "DEBUG in netapp.rb method missing " + name.to_s
#        debug("#{self.class}::method_missing")
    end
end
