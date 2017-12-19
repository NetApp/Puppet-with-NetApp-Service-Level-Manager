Puppet::Type.newtype(:slo_nfsshare) do
    @doc = "Storage Service Based nfsshare management using NSLM"

    apply_to_device

    ensurable
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
    newparam(:export_policy_key) do
        desc "parameter.description"
    end
    newparam(:export_policy_name) do
        desc "parameter.description"
    end
    newparam(:export_policy_storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:export_policy_storage_vm_storage_system_name) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
    newparam(:name) do
        desc "parameter.description"
    isnamevar
    end
end