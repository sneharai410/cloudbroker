json.extract! host, :id, :datacenter_id, :ram, :storage, :bandwidth, :pe_count, :created_at, :updated_at
json.url host_url(host, format: :json)
