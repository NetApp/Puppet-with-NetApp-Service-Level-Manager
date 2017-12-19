Puppet::Type.newtype(:slo_lun) do
    @doc = "Storage Service Based lun management using NSLM"

    apply_to_device

    ensurable

    newparam(:name) do
        desc "parameter.description"
    isnamevar
    end

    newparam(:size) do
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

    newparam(:storage_pool_key) do
        desc "parameter.description"
    end

    newparam(:storage_pool_name) do
        desc "parameter.description"
    end

    newparam(:storage_pool_storage_system_name) do
        desc "parameter.description"
    end

    newparam(:storage_service_level_key) do
        desc "parameter.description"
    end

    newparam(:storage_service_level_name) do
        desc "parameter.description"
    end

    newparam(:host_usage) do
        desc "parameter.description"
    end

    newparam(:key) do
        desc "parameter.description"
    end

    newparam(:operational_state) do
        desc "parameter.description"
    end
end
