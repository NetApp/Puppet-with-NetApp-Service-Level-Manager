#====================================================================
# Copyright (c) 2017 NetApp, Inc. All rights reserved.
# Specifications subject to change without notice.
#
# Disclaimer: This script is written as best effort and provides no
# warranty expressed or implied. Please contact the author(s) if you
# have questions about this script before running or modifying.
#====================================================================

require 'puppet/util/network_device'
require 'puppet/util/network_device/netapp/facts'
require 'puppet/netapp_api'

class Puppet::Util::NetworkDevice::Netapp::Device
    attr_accessor :transport
    def initialize(url, option = {})
        @transport = NetAppApi.new(url)
        if Puppet[:debug]
            @transport.debug = true
        end
    end

    def facts
        @facts ||= Puppet::Util::NetworkDevice::Netapp::Facts.new(@transport)
        thefacts = @facts.retrieve
        thefacts
    end
end
