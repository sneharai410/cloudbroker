class SMOM
    attr_accessor :monkeys, :best_solution, :best_fitness, :w1, :w2
  
    def initialize(sim_results, w1, w2, num_monkeys, max_iterations)
      @monkeys = []
      @best_solution = nil
      @best_fitness = Float::INFINITY
      @w1 = w1
      @w2 = w2
  
      # Initialize spider monkeys (solutions)
      num_monkeys.times do
        monkey = Monkey.new(sim_results, w1, w2)
        @monkeys << monkey
      end
  
      # Run optimization
      run(max_iterations)
    end
  
    def run(max_iterations,simulation_results)
      max_iterations.times do
        @monkeys.each do |monkey|
          monkey.explore(@best_solution)
          monkey.evaluate
  
          # Update the best solution found by the monkeys
          if monkey.fitness < @best_fitness
            @best_fitness = monkey.fitness
            @best_solution = monkey.position
          end
        end
      end
    end
  end
  
  class Monkey
    attr_accessor :position, :fitness
  
    def initialize(sim_results, w1, w2) 
      @position = sim_results.sample # Random initial position (solution)
      @fitness = evaluate
    end
  
    def evaluate
      # Evaluate the fitness of the current solution
      @position[:cost] * @w1 + @position[:execution_time] * @w2
    end
  
    def explore(best_solution)
      # Simulate exploration and exploitation behavior
      # Monkeys explore better solutions based on their own experience and the best solution
      if rand < 0.5
        # Exploration (move in random direction)
      else
        # Exploitation (move towards the best solution)
        @position = @position + 0.5 * (best_solution - @position)
      end
    end
  end
  
  # Usage
  w1 = 0.7
  w2 = 0.3
  num_monkeys = 30
  max_iterations = 100
  sim_results = SimulationResult.where(cloudlet_id: cloudlet).where.not(datacenter_id: nil)
  
  smo = SMO.new(sim_results, w1, w2, num_monkeys, max_iterations)
  
  # Result: Best combination of VM and Datacenter
  puts "Best VM ID: #{smo.best_solution[:vm_id]}"
  puts "Best Datacenter ID: #{smo.best_solution[:datacenter_id]}"
  puts "Best Fitness: #{smo.best_fitness}"
  