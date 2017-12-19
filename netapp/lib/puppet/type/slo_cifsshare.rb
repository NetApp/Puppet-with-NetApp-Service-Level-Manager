Puppet::Type.newtype(:slo_cifsshare) do
    @doc = "Storage Service Based cifsshare management using NSLM"

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
    newparam(:file_share_key) do
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
    newparam(:directory) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
end