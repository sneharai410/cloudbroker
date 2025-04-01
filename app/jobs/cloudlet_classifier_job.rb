class CloudletClassifierJob < ApplicationJob
  queue_as :default

  def perform(*args)
    cloudlet_ids = Cloudlet.where(workload_type:"cpu_intensive").pluck(:id)
    simulations = SimulationResult.where(cloudlet_id:cloudlet_ids)
    simulations.update_all(workload_type:"cpu_intensive")
    cloudlet_ids = Cloudlet.where(workload_type:"storage_intensive").pluck(:id)
    simulations = SimulationResult.where(cloudlet_id:cloudlet_ids)
    simulations.update_all(workload_type:"storage_intensive")
    cloudlet_ids = Cloudlet.where(workload_type:"io_intensive").pluck(:id)
    simulations = SimulationResult.where(cloudlet_id:cloudlet_ids)
    simulations.update_all(workload_type:"io_intensive")
    cloudlet_ids = Cloudlet.where(workload_type:"other").pluck(:id)
    simulations = SimulationResult.where(cloudlet_id:cloudlet_ids)
    simulations.update_all(workload_type:"other")

    # Do something later
  end
end
