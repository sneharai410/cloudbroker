json.extract! cloudlet, :id, :length, :file_size, :output_size, :workload_type, :created_at, :updated_at
json.url cloudlet_url(cloudlet, format: :json)
