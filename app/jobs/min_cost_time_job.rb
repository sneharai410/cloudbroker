require 'benchmark'

class MinCostTimeJob < ApplicationJob
  queue_as :default

  def perform(*args)
   

    Cloudlet.all.each do |cloudlet|
      w1 = 0.7
      w2 = 0.3
      sim_results = SimulationResult.where(cloudlet_id:cloudlet.id)
      # hash_result = greedy_algorithm(w1,w2,sim_results)
      hash_result = greedy_algorithm_modified(w1, w2, sim_results)
      CompareAlgo.create(hash_result)
    end 

  end

    def greedy_algorithm(w1,w2,sim_results)
      algo_name = "greedy"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil 
      op_cost = nil
      op_time = nil
      time = Benchmark.realtime do 
        sim_results.each do |sim|
        cost = sim.cost
        exe_time = sim.execution_time
        obj_value = w1 * cost + w2 * exe_time
          if obj_value < best_cost_time 
            op_cost = cost
            op_time = exe_time
            best_cost_time = obj_value
            best_vm_id = sim.vm_id
            best_datacenter = sim.datacenter_id
          end
        end
      end
      
      return { cloudlet_id:sim_results.pluck(:cloudlet_id).uniq.last,
              algo:algo_name,
              min_cost:op_cost, 
              min_executn_time:op_time,
              instance_type_id:best_vm_id,
              datacenter_id:best_datacenter,
              algo_eff_time:time.round(10)
              }
    end 

    def greedy_algorithm_modified(w1, w2, sim_results)
      algo_name = "greedy_modfied"
      best_result = nil
      # Use `min_by` to find the best result instead of manually iterating
      time = Benchmark.realtime do
        best_result = sim_results.min_by { |sim| w1 * sim.cost + w2 * sim.execution_time }
      end
      # Extract values from the best result
        if best_result
          {
            cloudlet_id: best_result.cloudlet_id,  # Optimize retrieval
            algo: algo_name,
            min_cost: best_result.cost,
            min_executn_time: best_result.execution_time,
            instance_type_id: best_result.vm_id,
            datacenter_id: best_result.datacenter_id,
            algo_eff_time: time.round(10)
          }
        else
          return {} # Return an empty hash if no results are found
        end
    end


end
