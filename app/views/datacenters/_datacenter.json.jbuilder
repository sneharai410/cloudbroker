json.extract! datacenter, :id, :name, :num_hosts, :pe_mips, :ram, :storage, :bandwidth, :scheduling_policy, :power_model, :latency, :topology, :bandwidth_policy, :storage_type, :cpu_cost, :ram_cost, :storage_cost, :bw_cost, :power_usage, :idle_power, :autoscaling, :created_at, :updated_at
json.url datacenter_url(datacenter, format: :json)
