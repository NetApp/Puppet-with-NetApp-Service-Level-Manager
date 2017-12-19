Puppet::Type.newtype(:slo_lunmap) do
    @doc = "Storage Service Based lunmap management using NSLM"

    apply_to_device

    ensurable
    newparam(:lun_key) do
        desc "parameter.description"
	isnamevar
    end
    newparam(:lun_name) do
        desc "parameter.description"
    end
    newparam(:lun_storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:lun_storage_vm_storage_system_name) do
        desc "parameter.description"
    end
    newparam(:initiator_group_key) do
        desc "parameter.description"
    end
    newparam(:initiator_group_name) do
        desc "parameter.description"
    end
    newparam(:initiator_group_storage_vm_name) do
        desc "parameter.description"
    end
    newparam(:initiator_group_storage_vm_storage_system_name) do
        desc "parameter.description"
    end
    newparam(:lun_id) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
end