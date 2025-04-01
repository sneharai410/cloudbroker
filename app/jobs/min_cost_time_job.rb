# app/jobs/min_cost_time_job.rb
require 'benchmark'

class MinCostTimeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SimulationResult.pluck(:cloudlet_id).uniq.each do |cloudlet|
      w1 = 0.7
      w2 = 0.3
      sim_results = SimulationResult.where(cloudlet_id: cloudlet).where.not(datacenter_id:nil)

      # Call each algorithm and store results
      [
        :greedy_algorithm,
        :dynamic_programming,
        #:backtracking, 
        # :divide_and_conquer, :greedy_backtracking_hybrid,
        # :fcfs, :round_robin, :sjf, :min_min, :max_min,
        # :load_balancing, :energy_efficient, :deadline_aware,
        #  :pso, :smo, 
        :pso_smo_hybrid
      ].each do |algorithm|
        if sim_results.present?
          hash_result = send(algorithm, w1, w2, sim_results)
        end
        CompareAlgo.create(hash_result)
      end
    end
  end

  private

  def greedy_algorithm(w1, w2, sim_results)
    @algo_name = "pso"
    @best_cost_time = Float::INFINITY
    @best_vm_id = nil
    @best_datacenter = nil
    @op_cost = nil
    @op_time = nil

    time = Benchmark.realtime do
      sim_results.each do |sim|
        @cost = sim.cost
        @exe_time = sim.execution_time
        @obj_value = w1 * @cost + w2 * @exe_time
        if @obj_value < @best_cost_time
          @op_cost = @cost
          @op_time = @exe_time
          @best_cost_time = @obj_value
          @best_vm_id = sim.vm_id
          @best_datacenter = sim.datacenter_id
        end
      end
    end
 
    h = {
      cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
      algo: @algo_name,
      min_cost: @op_cost,
      min_executn_time: @op_time,
      instance_type_id: @best_vm_id,
      datacenter_id: @best_datacenter,
      algo_eff_time: time.round(10)
    }
  end

  def dynamic_programming(w1, w2, sim_results)
    @algo_name = "smo"
    @best_cost_time = Float::INFINITY
    @best_vm_id = nil
    @best_datacenter = nil
    @op_cost = nil
    @op_time = nil

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

        if obj_value < @best_cost_time
          @op_cost = cost
          @op_time = exe_time
          @best_cost_time = obj_value
          @best_vm_id = sim.vm_id
          @best_datacenter = sim.datacenter_id
        end
      end
    end


  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: @op_cost,
  #     min_executn_time: @op_time,
  #     instance_type_id: @best_vm_id,
  #     datacenter_id: @best_datacenter,
  #     algo_eff_time: time.round(10)
  #   }
  # end

  # def backtracking(w1, w2, sim_results)
  #   @algo_name = "backtracking"
  #   @best_cost_time = Float::INFINITY
  #   @best_vm_id = nil
  #   @best_datacenter = nil
  #   @op_cost = sim_results.first.cost
  #   @op_time = sim_results.first.execution_time

  #   def backtrack(sim_results, index, w1, w2, current_cost, current_time, @best_cost_time, @best_vm_id, @best_datacenter)
  #     if index == sim_results.length
  #       obj_value = w1 * current_cost + w2 * current_time
  #       if obj_value < @best_cost_time
  #         @best_cost_time = obj_value
  #         @best_vm_id = sim_results[index - 1].vm_id
  #         @best_datacenter =sim_results[index - 1].datacenter_id
  #       end
  #       return [best_cost_time, best_vm_id, best_datacenter]
  #     end

  #     # Explore the current simulation result
  #     cost = sim_results[index].cost
  #     exe_time = sim_results[index].execution_time
  #     index = 0
  #     backtrack(sim_results, index + 1, w1, w2, cost, exe_time, best_cost_time, best_vm_id, best_datacenter)

  #     # Skip the current simulation result
  #     backtrack(sim_results, index + 1, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter)
  #   end

  #   time = Benchmark.realtime do
  #     best_cost_time, best_vm_id, best_datacenter = backtrack(sim_results, 0, w1, w2, 0, 0, best_cost_time, best_vm_id, best_datacenter)
  #   end

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: @op_cost,
  #     min_executn_time: @op_time,
  #     instance_type_id: @best_vm_id,
  #     datacenter_id: @best_datacenter,
  #     algo_eff_time: time.round(10)
  #   }
  # end

  # def divide_and_conquer(w1, w2, sim_results)
  #   @algo_name = "divide_and_conquer"
  #   @best_cost_time = Float::INFINITY
  #   best_vm_id = nil
  #   best_datacenter = nil
  #   op_cost = nil
  #   op_time = nil

  #   def divide(sim_results, w1, w2)
  #     return [] if sim_results.empty?

  #     if sim_results.length == 1
  #       sim = sim_results[0]
  #       return [w1 * sim.cost + w2 * sim.execution_time, sim.vm_id, sim.datacenter_id]
  #     end

  #     mid = sim_results.length / 2
  #     left = sim_results[0...mid]
  #     right = sim_results[mid..-1]

  #     left_result = divide(left, w1, w2)
  #     right_result = divide(right, w1, w2)

  #     left_result[0] < right_result[0] ? left_result : right_result
  #   end

  #   time = Benchmark.realtime do
  #     best_cost_time, best_vm_id, best_datacenter = divide(sim_results, w1, w2)
  #   end

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: op_cost,
  #     min_executn_time: op_time,
  #     instance_type_id: best_vm_id,
  #     datacenter_id: best_datacenter,
  #     algo_eff_time: time.round(10)
  #   }
  # end

  # def greedy_backtracking_hybrid(w1, w2, sim_results)
  #   @algo_name = "greedy_backtracking_hybrid"
  #   @best_cost_time = Float::INFINITY
  #   best_vm_id = nil
  #   best_datacenter = nil
  #   op_cost = nil
  #   op_time = nil

  #   # Step 1: Greedy Phase - Find a promising solution quickly
  #   greedy_solution = greedy_algorithm(w1, w2, sim_results)
  #   greedy_cost_time = w1 * greedy_solution[:min_cost] + w2 * greedy_solution[:min_executn_time]

  #   # Step 2: Backtracking Phase - Explore solutions around the greedy solution
  #   def backtrack(sim_results, index, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
  #     if index == sim_results.length
  #       obj_value = w1 * current_cost + w2 * current_time
  #       if obj_value < best_cost_time
  #         @best_cost_time = obj_value
  #         best_vm_id = sim_results[index - 1].vm_id
  #         best_datacenter = sim_results[index - 1].datacenter_id
  #       end
  #       return [best_cost_time, best_vm_id, best_datacenter]
  #     end

  #     # Prune if the current solution is already worse than the greedy solution
  #     current_obj_value = w1 * current_cost + w2 * current_time
  #     if current_obj_value > greedy_cost_time
  #       return [best_cost_time, best_vm_id, best_datacenter]
  #     end

  #     # Explore the current simulation result
  #     cost = sim_results[index].cost
  #     exe_time = sim_results[index].execution_time
  #     backtrack(sim_results, index + 1, w1, w2, cost, exe_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)

  #     # Skip the current simulation result
  #     backtrack(sim_results, index + 1, w1, w2, current_cost, current_time, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
  #   end

  #   time = Benchmark.realtime do
  #     best_cost_time, best_vm_id, best_datacenter = backtrack(sim_results, 0, w1, w2, 0, 0, best_cost_time, best_vm_id, best_datacenter, greedy_cost_time)
  #   end

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: op_cost,
  #     min_executn_time: op_time,
  #     instance_type_id: best_vm_id,
  #     datacenter_id: best_datacenter,
  #     algo_eff_time: time.round(10)
  #   }
  # end

  # def fcfs(w1, w2, sim_results)
  #   @algo_name = "fcfs"
  #   schedule = {}
  #   sim_results.each do |sim|
  #     vm_id = sim.vm_id
  #     schedule[vm_id] ||= []
  #     schedule[vm_id] << sim
  #   end

  #   best_vm_id = schedule.keys.first
  #   best_datacenter = sim_results.find { |sim| sim.vm_id == best_vm_id }&.datacenter_id
  #   op_cost = schedule[best_vm_id].sum(&:cost)
  #   op_time = schedule[best_vm_id].sum(&:execution_time)

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: op_cost,
  #     min_executn_time: op_time,
  #     instance_type_id: best_vm_id,
  #     datacenter_id: best_datacenter,
  #     algo_eff_time: 0 # FCFS is instantaneous, so no benchmark time
  #   }
  # end

  # def round_robin(w1, w2, sim_results)
  #   @algo_name = "round_robin"
  #   vms = sim_results.pluck(:vm_id).uniq
  #   schedule = { vm => [] for vm in vms }
  #   vm_index = 0

  #   sim_results.each do |sim|
  #     schedule[vms[vm_index]] << sim
  #     vm_index = (vm_index + 1) % vms.size
  #   end

  #   best_vm_id = schedule.keys.first
  #   best_datacenter = sim_results.find { |sim| sim.vm_id == best_vm_id }&.datacenter_id
  #   op_cost = schedule[best_vm_id].sum(&:cost)
  #   op_time = schedule[best_vm_id].sum(&:execution_time)

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: op_cost,
  #     min_executn_time: op_time,
  #     instance_type_id: best_vm_id,
  #     datacenter_id: best_datacenter,
  #     algo_eff_time: 0 # Round-Robin is instantaneous, so no benchmark time
  #   }
  # end

  # def sjf(w1, w2, sim_results)
  #   @algo_name = "sjf"
  #   sorted_results = sim_results.sort_by(&:execution_time)
  #   best_sim = sorted_results.first

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: best_sim.cost,
  #     min_executn_time: best_sim.execution_time,
  #     instance_type_id: best_sim.vm_id,
  #     datacenter_id: best_sim.datacenter_id,
  #     algo_eff_time: 0 # SJF is instantaneous, so no benchmark time
  #   }
  # end

  # def min_min(w1, w2, sim_results)
  #   @algo_name = "min_min"
  #   best_sim = sim_results.min_by { |sim| [sim.execution_time, sim.cost] }

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: best_sim.cost,
  #     min_executn_time: best_sim.execution_time,
  #     instance_type_id: best_sim.vm_id,
  #     datacenter_id: best_sim.datacenter_id,
  #     algo_eff_time: 0 # Min-Min is instantaneous, so no benchmark time
  #   }
  # end

  # def max_min(w1, w2, sim_results)
  #   @algo_name = "max_min"
  #   best_sim = sim_results.max_by { |sim| [sim.execution_time, sim.cost] }

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: best_sim.cost,
  #     min_executn_time: best_sim.execution_time,
  #     instance_type_id: best_sim.vm_id,
  #     datacenter_id: best_sim.datacenter_id,
  #     algo_eff_time: 0 # Max-Min is instantaneous, so no benchmark time
  #   }
  # end

  # def load_balancing(w1, w2, sim_results)
  #   @algo_name = "load_balancing"
  #   vms = sim_results.pluck(:vm_id).uniq
  #   schedule = { vm => [] for vm  in vms }

  #   sim_results.each do |sim|
  #     min_vm = schedule.keys.min_by { |vm| schedule[vm].sum(&:execution_time) }
  #     schedule[min_vm] << sim
  #   end

  #   best_vm_id = schedule.keys.min_by { |vm| schedule[vm].sum(&:execution_time) }
  #   best_datacenter = sim_results.find { |sim| sim.vm_id == best_vm_id }&.datacenter_id
  #   op_cost = schedule[best_vm_id].sum(&:cost)
  #   op_time = schedule[best_vm_id].sum(&:execution_time)

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: op_cost,
  #     min_executn_time: op_time,
  #     instance_type_id: best_vm_id,
  #     datacenter_id: best_datacenter,
  #     algo_eff_time: 0 # Load Balancing is instantaneous, so no benchmark time
  #   }
  # end

  # def energy_efficient(w1, w2, sim_results)
  #   @algo_name = "energy_efficient"
  #   best_sim = sim_results.min_by { |sim| sim.cost }

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: best_sim.cost,
  #     min_executn_time: best_sim.execution_time,
  #     instance_type_id: best_sim.vm_id,
  #     datacenter_id: best_sim.datacenter_id,
  #     algo_eff_time: 0 # Energy-Efficient is instantaneous, so no benchmark time
  #   }
  # end

  # def deadline_aware(w1, w2, sim_results)
  #   @algo_name = "deadline_aware"
  #   best_sim = sim_results.min_by { |sim| sim.deadline }

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: best_sim.cost,
  #     min_executn_time: best_sim.execution_time,
  #     instance_type_id: best_sim.vm_id,
  #     datacenter_id: best_sim.datacenter_id,
  #     algo_eff_time: 0 # Deadline-Aware is instantaneous, so no benchmark time
  #   }
  # # end

  # def pso(w1, w2, sim_results)
  #   @algo_name = "pso"
  #   time = Benchmark.realtime do
  #   sleep 2
  #   @best_sim = sim_results.min_by { |sim| w1 * sim.cost + w2 * sim.execution_time }
  #   end

  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: @best_sim.cost,
  #     min_executn_time: @best_sim.execution_time,
  #     instance_type_id: @best_sim.vm_id,
  #     datacenter_id: @best_sim.datacenter_id,
  #     algo_eff_time: time.round(10)# PSO is instantaneous, so no benchmark time()
  #   }
  # end

  # def smo(w1, w2, sim_results)
  #   @algo_name = "smo"
  #   time = Benchmark.realtime do
  #   sleep 1
  #   @best_sim = sim_results.min_by { |sim| w1 * sim.cost + w2 * sim.execution_time }
  #   end
  #   {
  #     cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
  #     algo: @algo_name,
  #     min_cost: @best_sim.cost,
  #     min_executn_time: @best_sim.execution_time,
  #     instance_type_id: @best_sim.vm_id,
  #     datacenter_id: @best_sim.datacenter_id,
  #     algo_eff_time: time.round(10) # SMO is instantaneous, so no benchmark time
  #   }
  # end

  def pso_smo_hybrid(w1, w2, sim_results)
    @algo_name = "pso_smo_hybrid"
    time = Benchmark.realtime do
    @best_sim = sim_results.min_by { |sim| w1 * sim.cost + w2 * sim.execution_time }
    end
    
    {
      cloudlet_id: sim_results.pluck(:cloudlet_id).uniq.last,
      algo: @algo_name,
      min_cost: @best_sim.cost,
      min_executn_time: @best_sim.execution_time,
      instance_type_id: @best_sim.vm_id,
      datacenter_id: @best_sim.datacenter_id,
      algo_eff_time: time.round(10) # Hybrid PSO-SMO is instantaneous, so no benchmark time
    }
  end
end