json.extract! vm, :id, :datacenter_id, :mips, :ram, :storage, :bandwidth, :created_at, :updated_at
json.url vm_url(vm, format: :json)
