Puppet::Type.newtype(:slo_initiatorgroup) do
    @doc = "Storage Service Based initiatorgroup management using NSLM"

    apply_to_device

    ensurable
    newparam(:name) do
        desc "parameter.description"
    isnamevar
    end
    newparam(:initiator_os_type) do
        desc "parameter.description"
    end
    newparam(:initiators) do
        desc "parameter.description"
    end
    newparam(:storage_vm_key) do
        desc "parameter.description"
    end
    newparam(:storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:storage_vm_storage_system_name) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
end