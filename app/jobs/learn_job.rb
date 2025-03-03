class LearnJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Datacenter.all.each do |datacenter|
      Dir.glob([Rails.root.to_s,"public","aws","*.json"].join("/")).each do |file|
        data = JSON.parse(File.open(file).read)
        data["datacenter_id"] = datacenter.id
        data["pricePerHour"] =  data["pricePerHour"].to_f + datacenter.cpu_cost.to_f + datacenter.ram_cost.to_f + datacenter.storage_cost.to_f + datacenter.bw_cost.to_f
        InstanceType.create(data)
      end
    end
    # Do something later
  end
end
