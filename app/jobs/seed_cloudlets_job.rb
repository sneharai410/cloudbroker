class SeedCloudletsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Create CPU-intensive Cloudlets
    200.times do
      Cloudlet.create!(
        length: rand(10000..15000),
        file_size: rand(512..1024),
        output_size: rand(1024..2048),
        workload_type: :cpu_intensive
      )
    end

    # Create storage-intensive Cloudlets
    200.times do
      Cloudlet.create!(
        length: rand(5000..10000),
        file_size: rand(2048..4096),
        output_size: rand(4096..8192),
        workload_type: :storage_intensive
      )
    end

    # Create I/O-intensive Cloudlets
    200.times do
      Cloudlet.create!(
        length: rand(5000..10000),
        file_size: rand(512..1024),
        output_size: rand(1024..2048),
        workload_type: :io_intensive
      )
    end

    # Create other Cloudlets
    200.times do
      Cloudlet.create!(
        length: rand(5000..10000),
        file_size: rand(512..1024),
        output_size: rand(1024..2048),
        workload_type: :other
      )
    end

    puts "Successfully seeded #{Cloudlet.count} Cloudlets."
  end
end