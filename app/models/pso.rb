class PSO
    attr_accessor :swarm, :global_best_position, :global_best_fitness, :w1, :w2
  
    def initialize(sim_results, w1, w2, num_particles, max_iterations)
      @swarm = []
      @global_best_position = nil
      @global_best_fitness = Float::INFINITY
      @w1 = w1
      @w2 = w2
  
      # Initialize particles
      num_particles.times do
        particle = Particle.new(sim_results, w1, w2)
        @swarm << particle
      end
  
      # Run the optimization
      run(max_iterations)
    end
  
    def run(max_iterations)
      max_iterations.times do |iteration|
        @swarm.each do |particle|
          particle.update_velocity(@global_best_position)
          particle.update_position
  
          # Evaluate the fitness of the particle
          fitness = particle.fitness
          if fitness < @global_best_fitness
            @global_best_fitness = fitness
            @global_best_position = particle.position
          end
        end
      end
    end
  end
  
  class Particle
    attr_accessor :position, :velocity, :best_position, :best_fitness
  
    def initialize(sim_results, w1, w2)
      @position = sim_results.sample # Randomly choose a VM-Datacenter combination
      @velocity = [rand, rand] # Random velocity
      @best_position = @position
      @best_fitness = fitness
    end
  
    def fitness
      # Evaluate the fitness of this particle based on the cost and execution time
      @position[:cost] * @w1 + @position[:execution_time] * @w2
    end
  
    def update_velocity(global_best_position)
      # Update velocity based on personal best and global best
      inertia = 0.7
      cognitive = 1.4
      social = 1.4
  
      r1 = rand
      r2 = rand
  
      @velocity = inertia * @velocity +
                  cognitive * r1 * (@best_position - @position) +
                  social * r2 * (global_best_position - @position)
    end
  
    def update_position
      # Update the particle's position based on velocity
      @position = @position + @velocity
      # Ensure the position stays within bounds (VM-Datacenter combinations)
    end
  end
  
  # Usage
  w1 = 0.7
  w2 = 0.3
  num_particles = 30
  max_iterations = 100
  sim_results = SimulationResult.where(cloudlet_id: cloudlet).where.not(datacenter_id: nil)
  
  pso = PSO.new(sim_results, w1, w2, num_particles, max_iterations)
  
  # Result: Best combination of VM and Datacenter
  puts "Best VM ID: #{pso.global_best_position[:vm_id]}"
  puts "Best Datacenter ID: #{pso.global_best_position[:datacenter_id]}"
  puts "Best Fitness: #{pso.global_best_fitness}"
  