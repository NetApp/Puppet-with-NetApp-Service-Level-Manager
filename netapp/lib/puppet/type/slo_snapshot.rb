Puppet::Type.newtype(:slo_snapshot) do
    @doc = "Storage Service Based snapshot management using NSLM"

    apply_to_device

    ensurable
    newparam(:name) do
        desc "parameter.description"
    isnamevar
    end
    newparam(:retention_type) do
        desc "parameter.description"
    end
    newparam(:comment) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
    newparam(:file_share_name) do
        desc "parameter.description"
    end
    newparam(:file_share_storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:file_share_storage_vm_storage_system_name) do
        desc "parameter.description"
    end
end