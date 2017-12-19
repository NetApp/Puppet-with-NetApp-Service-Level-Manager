Puppet::Type.newtype(:slo_exportpolicy) do
    @doc = "Storage Service Based exportpolicy management using NSLM"

    apply_to_device

    ensurable
    newparam(:name) do
        desc "parameter.description"
    isnamevar
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
    newparam(:ro_hosts) do
        desc "parameter.description"
    end
    newparam(:rw_hosts) do
        desc "parameter.description"
    end
    newparam(:root) do
        desc "parameter.description"
    end
    newparam(:security_type) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
end