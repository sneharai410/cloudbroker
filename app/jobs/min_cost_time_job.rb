require 'benchmark'

class MinCostTimeJob < ApplicationJob
  queue_as :default

  def perform(*args)
  
    Cloudlet.all.each do |cloudlet|
      w1 = 0.7
      w2 = 0.3
      sim_results = SimulationResult.where(cloudlet_id:cloudlet.id)
      hash_result = greedy_algorithm(w1,w2,sim_results)
      CompareAlgo.create(hash_result)
      hash_result = dynamic_programming(w1,w2,sim_results)
      CompareAlgo.create(hash_result)
      # hash_result = backtracking(w1,w2,sim_results)
      # CompareAlgo.create(hash_result)
      hash_result = divide_and_conquer(w1,w2,sim_results)
      CompareAlgo.create(hash_result)
      # hash_result = greedy_backtracking_hybrid(w1,w2,sim_results)
      # CompareAlgo.create(hash_result)

    end 

  end

    def greedy_algorithm(w1,w2,sim_results)
      algo_name = "greedy"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil 
      op_cost = nil
      op_time = nil
       time= Benchmark.realtime do 
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

    def dynamic_programming(w1, w2, sim_results)
      algo_name = "dynamic_programming"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil
      op_cost = nil
      op_time = nil
    
      # Memoization table to store intermediate results
      dp = {}
    
      time = Benchmark.realtime do
        sim_results.each do |sim|
          cost = sim.cost
          exe_time = sim.execution_time
          obj_value = w1 * cost + w2 * exe_time
    
          # Use cloudlet_id as the key for memoization
          key = "#{sim.cloudlet_id}_#{sim.vm_id}_#{sim.datacenter_id}"
          if !dp[key] || obj_value < dp[key][:obj_value]
            dp[key] = { obj_value: obj_value, cost: cost, exe_time: exe_time, vm_id: sim.vm_id, datacenter_id: sim.datacenter_id }
          end
    
          if obj_value < best_cost_time
            op_cost = cost
            op_time = exe_time
            best_cost_time = obj_value
            best_vm_id = sim.vm_id
            best_datacenter = sim.datacenter_id
          end
        end
      end
    
      return {
        cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
        algo: algo_name,
        min_cost: op_cost,
        min_executn_time: op_time,
        instance_type_id: best_vm_id,
        datacenter_id: best_datacenter,
        algo_eff_time: time.round(10)
      }
    end

    def backtracking(w1, w2, sim_results)
      algo_name = "backtracking"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil
      op_cost = nil
      op_time = nil
    
      def backtrack(sim_results, index, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter)
        if index == sim_results.length
          obj_value = w1 * current_cost + w2 * current_time
          if obj_value < best_cost_time
            best_cost_time = obj_value
            best_vm_id = sim_results[index - 1].vm_id
            best_datacenter = sim_results[index - 1].datacenter_id
          end
          return [best_cost_time, best_vm_id, best_datacenter]
        end
    
        # Explore the current simulation result
        cost = sim_results[index].cost
        exe_time = sim_results[index].execution_time
        backtrack(sim_results, index + 1, w1, w2, cost, exe_time, best_cost_time, best_vm_id, best_datacenter)
    
        # Skip the current simulation result
        backtrack(sim_results, index + 1, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter)
      end
    
      time = Benchmark.realtime do
        best_cost_time, best_vm_id, best_datacenter = backtrack(sim_results, 0, w1, w2, 0, 0, best_cost_time, best_vm_id, best_datacenter)
      end
    
      return {
        cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
        algo: algo_name,
        min_cost: op_cost,
        min_executn_time: op_time,
        instance_type_id: best_vm_id,
        datacenter_id: best_datacenter,
        algo_eff_time: time.round(10)
      }
    end

    def divide_and_conquer(w1, w2, sim_results)
      algo_name = "divide_and_conquer"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil
      op_cost = nil
      op_time = nil
    
      def divide(sim_results, w1, w2)
        return [] if sim_results.empty?
    
        if sim_results.length == 1
          sim = sim_results[0]
          return [w1 * sim.cost + w2 * sim.execution_time, sim.vm_id, sim.datacenter_id]
        end
    
        mid = sim_results.length / 2
        left = sim_results[0...mid]
        right = sim_results[mid..-1]
    
        left_result = divide(left, w1, w2)
        right_result = divide(right, w1, w2)
    
        left_result[0] < right_result[0] ? left_result : right_result
      end
    
      time = Benchmark.realtime do
        best_cost_time, best_vm_id, best_datacenter = divide(sim_results, w1, w2)
      end
    
      return {
        cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
        algo: algo_name,
        min_cost: op_cost,
        min_executn_time: op_time,
        instance_type_id: best_vm_id,
        datacenter_id: best_datacenter,
        algo_eff_time: time.round(10)
      }
    end

    def greedy_backtracking_hybrid(w1, w2, sim_results)
      algo_name = "greedy_backtracking_hybrid"
      best_cost_time = Float::INFINITY
      best_vm_id = nil
      best_datacenter = nil
      op_cost = nil
      op_time = nil
    
      # Step 1: Greedy Phase - Find a promising solution quickly
      greedy_solution = greedy_algorithm(w1, w2, sim_results)
      greedy_cost_time = w1 * greedy_solution[:min_cost] + w2 * greedy_solution[:min_executn_time]
    
      # Step 2: Backtracking Phase - Explore solutions around the greedy solution
      def backtrack(sim_results, index, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
        if index == sim_results.length
          obj_value = w1 * current_cost + w2 * current_time
          if obj_value < best_cost_time
            best_cost_time = obj_value
            best_vm_id = sim_results[index - 1].vm_id
            best_datacenter = sim_results[index - 1].datacenter_id
          end
          return [best_cost_time, best_vm_id, best_datacenter]
        end
    
        # Prune if the current solution is already worse than the greedy solution
        current_obj_value = w1 * current_cost + w2 * current_time
        if current_obj_value > greedy_cost_time
          return [best_cost_time, best_vm_id, best_datacenter]
        end
    
        # Explore the current simulation result
        cost = sim_results[index].cost
        exe_time = sim_results[index].execution_time
        backtrack(sim_results, index + 1, w1, w2, cost, exe_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
    
        # Skip the current simulation result
        backtrack(sim_results, index + 1, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
      end
    
      time = Benchmark.realtime do
        best_cost_time, best_vm_id, best_datacenter = backtrack(sim_results, 0, w1, w2, 0, 0, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
      end
    
      return {
        cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
        algo: algo_name,
        min_cost: op_cost,
        min_executn_time: op_time,
        instance_type_id: best_vm_id,
        datacenter_id: best_datacenter,
        algo_eff_time: time.round(10)
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
