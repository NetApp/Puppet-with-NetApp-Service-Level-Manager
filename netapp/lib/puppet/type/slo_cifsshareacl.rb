Puppet::Type.newtype(:slo_cifsshareacl) do
    @doc = "Storage Service Based cifsshareacl management using NSLM"

    apply_to_device

    ensurable
    newparam(:user_or_group) do
        desc "parameter.description"
    end
    newparam(:permission) do
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
    newparam(:cifs_share_key) do
        desc "parameter.description"
	isnamevar
    end
    newparam(:cifs_share_file_share_name) do
        desc "parameter.description"
    end
    newparam(:cifs_share_file_share_storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:cifs_share_file_share_storage_vm_storage_system_name) do
        desc "parameter.description"
    end
    newparam(:cifs_share_name) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
    newparam(:storage_platform_type) do
        desc "parameter.description"
    end
end