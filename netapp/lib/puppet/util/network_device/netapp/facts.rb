#====================================================================
# Copyright (c) 2017 NetApp, Inc. All rights reserved.
# Specifications subject to change without notice.
#
# Disclaimer: This script is written as best effort and provides no
# warranty expressed or implied. Please contact the author(s) if you
# have questions about this script before running or modifying.
#====================================================================

require 'puppet/util/network_device/netapp'

class Puppet::Util::NetworkDevice::Netapp::Facts
    attr_reader :transport, :url
    def initialize(transport)
        @transport = transport
    end

    def retrieve
        Puppet.debug "Retrieving Facts from #{@transport.redacted_url}"
        @facts = {}
        @facts["url"] = @transport.url.to_s
        @facts["vendor_id"] = 'netapp'
        @facts
    end
end
