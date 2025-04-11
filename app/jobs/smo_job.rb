class SmoJob < ApplicationJob
  queue_as :default

  def perform(*args)
    w1 = 0.7
    w2 = 0.3
    num_monkeys = 30
    max_iterations = 50
    $cost_min = SimulationResult.pluck(:vm_exec_cost).min # Replace with actual min from dataset
    $cost_max = SimulationResult.pluck(:vm_exec_cost).max # Replace with actual max from dataset
    $time_min = SimulationResult.pluck(:execution_time).min # Replace with actual min from dataset
    $time_max = SimulationResult.pluck(:execution_time).max # Replace with actual max from dataset

    h = []
    
    # @sim_res = SimulationResult.all
    Cloudlet.last(600).each do |cloudlet| 
      @sim_res = SimulationResult.where(workload_type: cloudlet.workload_type)
      # Get simulation results for this cloudlet's workload type
      time = Benchmark.realtime do
      @smo = Smoo.new(@sim_res, w1, w2, num_monkeys, max_iterations)
      end
      
      # Result: Best combination of VM and Datacenter
      # puts "Cloudlet ID: #{cloudlet.id}"
      # puts "Workload Type: #{cloudlet.workload_type}"
      # puts "Best VM ID: #{@smo.best_solution.vm_id}"
      # puts "Best Datacenter ID: #{@smo.best_solution.datacenter_id}"
      # puts "Best Fitness: #{@smo.best_fitness}"
      # puts "----------------------------------"

      h << {
        cloudlet_id: cloudlet.id,
        # algo: "smo_weight_based",
        #  algo: "smo_penality_based",
        #  algo: "smo_normalisation_based",        
        min_cost: @smo.best_solution.vm_exec_cost,
        min_executn_time: @smo.best_solution.execution_time,
        instance_type_id: @smo.best_solution.vm_id,
        datacenter_id: @smo.best_solution.datacenter_id,
        algo_eff_time: time.round(10)
      }
   
    end
    CompareAlgo.create!(h)
  end
end

class Smoo
  attr_accessor :monkeys, :best_solution, :best_fitness, :w1, :w2, :sim_results, :workload_type

  def initialize(sim_results, w1, w2, num_monkeys, max_iterations)
    @sim_results = sim_results.group_by { |result| [result.datacenter_id, result.vm_id] }
    @w1 = w1
    @w2 = w2
    @monkeys = []
    @best_solution = nil
    @best_fitness = Float::INFINITY

    # Initialize spider monkeys (solutions)
    num_monkeys.times do
      @monkeys << Monkey.new(@sim_results, @w1, @w2)
    end
    run(max_iterations)
  end

  def run(max_iterations)
    max_iterations.times do
      @monkeys.each do |monkey|
        monkey.explore(@best_solution, @sim_results)
        monkey.evaluate
        
        if monkey.fitness < @best_fitness
          @best_fitness = monkey.fitness 
          @best_solution = monkey.position
        end
      end
    end
  end
end

class Monkey
  attr_accessor :position, :fitness, :w1, :w2

  def initialize(sim_results, w1, w2)
    @w1 = w1
    @w2 = w2
    @position = sim_results.values.flatten.sample # Random initial position
    @fitness = evaluate
  end

  # def evaluate
  #   @position.vm_exec_cost * @w1 + @position.execution_time * @w2
  # end

  # def evaluate
  #   norm_cost = (@position.vm_exec_cost - $cost_min) / ($cost_max - $cost_min).to_f
  #   norm_time = (@position.execution_time - $time_min) / ($time_max - $time_min).to_f
  #   (norm_cost * @w1) + (norm_time * @w2)
  # end

  # def evaluate
  #   alpha = 0.05  # Adjust based on your dataset
  #   beta = 0.02
  
  #   penalty_cost = Math.exp(alpha * @position.vm_exec_cost)
  #   penalty_time = Math.exp(beta * @position.execution_time)
  
  #   (penalty_cost * @w1) + (penalty_time * @w2)
  # end
  

  def explore(best_solution, sim_results)
    if best_solution.nil? || rand < 0.5
      # Exploration: random new position
      @position = sim_results.values.flatten.sample
    else
      # Exploitation: move toward best solution
      candidates = sim_results[[best_solution.datacenter_id , best_solution.vm_id ]]
      @position = candidates.sample || sim_results.values.flatten.sample
    end
  end
end
