# config/initializers/jar_loader.rb
Dir[Rails.root.join("lib/java_apis/*.jar")].each do |jar|
    puts "Loading JAR: #{jar}"
    require jar
  end

  
class Sim
  SLA_LIMITS = {
    "cpu_utilization" => 1.0,  # Max 80% CPU usage
    "ram_utilization" => 1.0,  # Max 70% RAM usage
    "bw_utilization" => 1.0 ,   # Max 90% Bandwidth usage
    "execution_time" => 50.0   # Max 50 seconds for Cloudlet
    }

  class << self
    def run
        Datacenter.all.each do |datacenter|
            cloudsim = CloudSimPlus.new
            host_list = Sim.create_hosts(datacenter)
            characteristics = DatacenterCharacteristicsSimple.new(datacenter.cpu_cost, datacenter.ram_cost, datacenter.storage_cost, datacenter.bw_cost)  

            vm_scheduling_policy =  case datacenter.scheduling_policy 
            when "VmAllocationPolicyRandom"
              VmAllocationPolicyRoundRobin.new
            when "VmAllocationPolicyRoundRobin"
              VmAllocationPolicyRoundRobin.new
            when "VmAllocationPolicyBestFit"
              VmAllocationPolicyBestFit.new
            when "VmAllocationPolicyFirstFit"
              VmAllocationPolicyFirstFit.new
            else
              VmAllocationPolicySimple.new
            end

            datacenter_sim = DatacenterSimple.new(cloudsim, host_list,vm_scheduling_policy)
            datacenter_sim.set_characteristics(characteristics)
            .set_name(datacenter.name)

            # print_host_details(datacenter_sim)
            vm_list = Sim.create_vm_list(datacenter)
            cloudlet_list = Sim.create_cloudlet_list()
            broker = DatacenterBrokerSimple.new(cloudsim, String.new( ["Broker",datacenter.name].join("_") ))
            broker.submit_vm_list(vm_list)    
            broker.submit_cloudlet_list(cloudlet_list)
            cloudsim.start
            Sim.report(datacenter,broker)
        end
    end

    def create_vm_list(datacenter)
      vm_list = java.util.ArrayList.new
      datacenter.instance_types.all.each do |instance|

         vm =  VmSimple.new(instance.cpus * 1000, instance.cpus) # 1000 MIPS per CPU
            .setId(instance.id)
            .setRam(instance.memoryInMB)
            .setBw(10000) # Bandwidth in Mbps
            .setSize(200000) # Storage in MB
            .setCloudletScheduler(CloudletSchedulerTimeShared.new) # Time-shared scheduler
            # .setDescription("Instance: #{instance[:name]}, Region: #{instance[:region]}, Price: $#{instance[:pricePerHour]}/hour")
          vm_list.add(vm)  

        end
        vm_list 
    end

    def create_cloudlet_list
      cloudlet_list = java.util.ArrayList.new
      Cloudlet.all.each do |cloudlet|
      cloudlet = CloudletSimple.new(cloudlet.length, 1, UtilizationModelFull.new)
      .setId(cloudlet.id)
      .setOutputSize(cloudlet.output_size)
      .setFileSize(cloudlet.file_size)
      cloudlet_list.add(cloudlet)
      end
      cloudlet_list
    end 

    def print_host_details(datacenter)
      host_list = datacenter.getHostLists

      # Log available resources in the datacenter
      host_list.each do |host|
        puts "Host ID: #{host.id}, " \
             "Available PEs: #{host.pe_list.size}, " \
             "Available RAM: #{host.ram}, " \
             "Available BW: #{host.bw}, " \
             "Available Storage: #{host.storage}"
      end
    end

    def create_hosts(datacenter)
        host_list = java.util.ArrayList.new
        host_pe_list = java.util.ArrayList.new
        datacenter.num_hosts.times do
          20.times do 
             host_pe_list.add(PeSimple.new(datacenter.pe_mips))
          end
          
          host = HostSimple.new( datacenter.ram , datacenter.bandwidth , datacenter.storage , host_pe_list)
              .setRamProvisioner(ResourceProvisionerSimple.new)
              .setBwProvisioner(ResourceProvisionerSimple.new)
              .set_vm_scheduler(VmSchedulerSpaceShared.new)

          host_list.add(host)

        end
        host_list
    end

    def report(datacenter,broker)
      puts "report started "
        # Generate and store the report
      broker.getCloudletFinishedList.each do |cloudlet|
          vm = cloudlet.getVm
          # Ensure the VM is not nil (in case the cloudlet is not assigned to any VM)
          if vm.nil?
            puts "Warning: Cloudlet #{cloudlet.getId} is not assigned to any VM."
            next
          end

          host = vm.get_host

          if host.nil?
            puts "Warning: VM #{vm.getId} is not assigned to any host."
            next
          end

          # Ensure the host is not nil (in case the VM is not assigned to any host)

           
            # Calculate execution time
            execution_time = cloudlet.getFinishTime - cloudlet.getStartTime
             puts "execution time #{execution_time}........................."
            # Calculate resource utilization
            cpu_utilization = cloudlet.getUtilizationOfCpu
            ram_utilization = cloudlet.getUtilizationOfRam
            bw_utilization = cloudlet.getUtilizationOfBw
            # storage_utilization = cloudlet.getUtilizationOfStorage
            puts "cost calulation started....................................."
             
              # Calculate cost
            cost = (execution_time * datacenter.cpu_cost * cpu_utilization) +
                      (execution_time * datacenter.ram_cost * ram_utilization) +
                      (execution_time * datacenter.bw_cost * bw_utilization) 
                      # (execution_time * datacenter.storage_cost * storage_utilization)
           
            puts "sla calulation started ....................................."
            cost_by_instance_type =  (InstanceType.find(vm.getId).pricePerHour * execution_time)


            execution_time_breach = execution_time > SLA_LIMITS["execution_time"]
            cpu_breach = cpu_utilization > SLA_LIMITS["cpu_utilization"]
            ram_breach = ram_utilization > SLA_LIMITS["ram_utilization"]
            bw_breach = bw_utilization > SLA_LIMITS["bw_utilization"]

            puts "sla breach cost calculation started .................. "

            # sla_breach_cost = 0
            # sla_breach_cost += datacenter.cpu_cost * execution_time if cpu_breach
            # sla_breach_cost += datacenter.ram_cost * execution_time if ram_breach
            # sla_breach_cost += datacenter.bw_cost * execution_time if bw_breach

            # puts "the sla cost is #{sla_breach_cost}....................."


            # Print debug information to the console
            puts "===== Debug Information ====="
            puts "Cloudlet ID: #{cloudlet.getId}"
            puts "VM ID: #{vm.getId}"
            puts "VM CPU Cores: #{vm.getPesNumber()}" # Use the correct method here
            puts "VM RAM: #{vm.getRam().getCapacity()}"
            puts "VM Storage: #{vm.getStorage().getCapacity()}"
            puts "VM BW: #{vm.getBw().getCapacity()}"
            puts "VM MIPS: #{vm.getMips()}"
            puts "Host ID: #{host.getId}"
            puts "Host CPU Cores: #{host.getPeList.size}"
            puts "Host RAM: #{host.getRam().getCapacity()}"
            puts "Host Storage: #{host.getStorage().getCapacity()}"
            puts "Host BW: #{host.getBw().getCapacity()}"
            puts "Host MIPS: #{host.getPeList.sum { |pe| pe.getCapacity }}"
            puts "Execution Time: #{execution_time}"
            puts "CPU Utilization: #{cpu_utilization}"
            puts "RAM Utilization: #{ram_utilization}"
            puts "BW Utilization: #{bw_utilization}"
            puts "Storage Utilization: #{}"
            puts "Execution Time Breach: #{execution_time_breach}"
            puts "CPU Breach: #{cpu_breach}"
            puts "RAM Breach: #{ram_breach}"
            puts "BW Breach: #{bw_breach}"
            puts "Cost: #{cost}"
            puts "SLA Breach Cost: #{cost_by_instance_type}"
            puts "Cloudlet Id #{cloudlet.getId}"
            puts "Cloudlet Pes Number #{cloudlet.getPesNumber}"
            puts "Cloudlet FileSize #{cloudlet.getFileSize}"
            puts "Cloudlet OutputSize #{cloudlet.getOutputSize}"
            puts "============================="
            
            # sla_breach_cost += datacenter.storage_cost * execution_time if execution_time_breach
            
            # Store the result in the database
           
          #Store the result in the database
            SimulationResult.create(
            datacenter_id: datacenter.id,
            datacenter_name: datacenter.name,
            datacenter_cpu_cost: datacenter.cpu_cost,
            datacenter_ram_cost: datacenter.ram_cost,
            datacenter_storage_cost: datacenter.storage_cost,
            datacenter_bw_cost: datacenter.bw_cost,
            host_id: host.getId,
            host_cpu_cores: host.getPeList.size, # Number of processing elements (PEs) in the host
            host_ram: host.getRam().getCapacity(), # RAM capacity of the host
            host_storage: host.getStorage().getCapacity(), # Storage capacity of the host
            host_bw: host.getBw().getCapacity(), # Bandwidth capacity of the host
            host_mips: host.getPeList.sum { |pe| pe.getCapacity },# Total MIPS of all PEs in the host
            vm_id: vm.getId,
            vm_cpu_cores: vm.getPesNumber(),
            vm_ram: vm.getRam().getCapacity(),
            vm_storage: vm.getStorage().getCapacity(),
            vm_bw: vm.getBw().getCapacity(),
            vm_mips: vm.getMips,
            cloudlet_id: cloudlet.getId,
            cloudlet_length: cloudlet.getLength,
            cloudlet_pes: cloudlet.getPesNumber,
            cloudlet_file_size: cloudlet.getFileSize,
            cloudlet_output_size: cloudlet.getOutputSize,
            execution_time: execution_time,
            cpu_utilization: cpu_utilization,
            ram_utilization: ram_utilization,
            bw_utilization: bw_utilization,
            storage_utilization: nil,
            execution_time_breach: execution_time_breach,
            cpu_breach: cpu_breach,
            ram_breach: ram_breach,
            bw_breach: bw_breach,
            cost: cost,
            sla_breach_cost: cost_by_instance_type)

      end

    end

    def load_class

      java_import "org.cloudsimplus.brokers.DatacenterBrokerSimple"
      java_import "org.cloudsimplus.cloudlets.CloudletSimple"
      java_import "org.cloudsimplus.core.CloudSimPlus"
      java_import "org.cloudsimplus.datacenters.DatacenterSimple"
      java_import "org.cloudsimplus.datacenters.DatacenterCharacteristicsSimple"
      java_import "org.cloudsimplus.hosts.HostSimple"
      java_import "org.cloudsimplus.provisioners.ResourceProvisioner"
      java_import "org.cloudsimplus.provisioners.ResourceProvisionerSimple"
      java_import "org.cloudsimplus.resources.PeSimple"
      java_import "org.cloudsimplus.schedulers.cloudlet.CloudletSchedulerTimeShared"
      java_import "org.cloudsimplus.schedulers.cloudlet.CloudletSchedulerSpaceShared"
      java_import "org.cloudsimplus.schedulers.vm.VmSchedulerTimeShared"
      java_import "org.cloudsimplus.schedulers.vm.VmSchedulerSpaceShared"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRoundRobin"
      java_import "org.cloudsimplus.utilizationmodels.UtilizationModelFull"
      java_import "org.cloudsimplus.vms.VmSimple"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRandom"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRoundRobin"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyBestFit"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyFirstFit"
      java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicySimple"
      java_import "java.util.ArrayList"
      # java_import "java.lang.String"
      java_import "org.cloudsimplus.slametrics.SlaContract"
      java_import "org.cloudsimplus.power.PowerAware"
      java_import "org.cloudsimplus.power.models.PowerModelDatacenterSimple"
      nil
    end
  end

  private 

  def load_class

    java_import "org.cloudsimplus.brokers.DatacenterBrokerSimple"
    java_import "org.cloudsimplus.cloudlets.CloudletSimple"
    java_import "org.cloudsimplus.core.CloudSimPlus"
    java_import "org.cloudsimplus.datacenters.DatacenterSimple"
    java_import "org.cloudsimplus.datacenters.DatacenterCharacteristicsSimple"
    java_import "org.cloudsimplus.hosts.HostSimple"
    java_import "org.cloudsimplus.provisioners.ResourceProvisioner"
    java_import "org.cloudsimplus.provisioners.ResourceProvisionerSimple"
    java_import "org.cloudsimplus.resources.PeSimple"
    java_import "org.cloudsimplus.schedulers.cloudlet.CloudletSchedulerTimeShared"
    java_import "org.cloudsimplus.schedulers.cloudlet.CloudletSchedulerSpaceShared"
    java_import "org.cloudsimplus.schedulers.vm.VmSchedulerTimeShared"
    java_import "org.cloudsimplus.schedulers.vm.VmSchedulerSpaceShared"
    java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRoundRobin"
    java_import "org.cloudsimplus.utilizationmodels.UtilizationModelFull"
    java_import "org.cloudsimplus.vms.VmSimple"
    java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRandom"
    java_import "org.cloudsimplus.allocationpolicies.VmAllocationPolicyRoundRobin"
    java_import "java.util.ArrayList"
    # java_import "java.lang.String"
    java_import "org.cloudsimplus.slametrics.SlaContract"
    java_import "org.cloudsimplus.power.PowerAware"
    java_import "org.cloudsimplus.power.models.PowerModelDatacenterSimple"

  end

end
    
