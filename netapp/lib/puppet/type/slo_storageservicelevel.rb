Puppet::Type.newtype(:slo_storageservicelevel) do
    @doc = "Storage Service Based storageservicelevel management using NSLM"

    apply_to_device

    ensurable
    newparam(:name) do
        desc "parameter.description"
    isnamevar
    end
    newparam(:description) do
        desc "parameter.description"
    end
    newparam(:peak_latency) do
        desc "parameter.description"
    end
    newparam(:peak_iops_per_tb) do
        desc "parameter.description"
    end
    newparam(:expected_iops_per_tb) do
        desc "parameter.description"
    end
    newparam(:key) do
        desc "parameter.description"
    end
end