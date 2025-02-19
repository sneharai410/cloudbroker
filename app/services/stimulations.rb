# config/initializers/jar_loader.rb
Dir[Rails.root.join("lib/java_apis/*.jar")].each do |jar|
    puts "Loading JAR: #{jar}"
    require jar
  end
require "pry"
  
class Stimulations 

    java_import "org.cloudsimplus.brokers.DatacenterBrokerSimple"
    java_import "org.cloudsimplus.cloudlets.CloudletSimple"
    java_import "org.cloudsimplus.core.CloudSimPlus"
    java_import "org.cloudsimplus.datacenters.DatacenterSimple"
    java_import "org.cloudsimplus.datacenters.DatacenterCharacteristicsSimple"
    java_import "org.cloudsimplus.hosts.HostSimple"
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
    java_import "java.lang.String"
    java_import "org.cloudsimplus.slametrics.SlaContract"
    java_import "org.cloudsimplus.power.PowerAware"
    java_import "org.cloudsimplus.power.models.PowerModelDatacenterSimple"


    SLA_LIMITS = {
    "cpu_utilization" => 0.8,  # Max 80% CPU usage
    "ram_utilization" => 0.7,  # Max 70% RAM usage
    "bw_utilization" => 0.9,   # Max 90% Bandwidth usage
    "execution_time" => 50.0   # Max 50 seconds for Cloudlet
    }

    def self.run_simulation
        cloudsim = CloudSimPlus.new

        Datacenter.last(2).each do |datacenter|
            stimulated_datacenter = Stimulations.create_datacenter(cloudsim , datacenter)
            broker = DatacenterBrokerSimple.new(cloudsim, String.new( ["Broker",datacenter.name].join("_") ))
            
           
            InstanceType.last(2).each do |instance|

                vm_list = java.util.ArrayList.new
               vm =  VmSimple.new(instance[:cpus] * 1000, instance[:cpus]) # 1000 MIPS per CPU
                  .setRam(instance[:memoryInMB])
                  .setBw(1000) # Bandwidth in Mbps
                  .setSize(10_000) # Storage in MB
                  .setCloudletScheduler(CloudletSchedulerTimeShared.new) # Time-shared scheduler
                  .setDescription("Instance: #{instance[:name]}, Region: #{instance[:region]}, Price: $#{instance[:pricePerHour]}/hour")
                vm_list.add(vm)  
                broker.submit_vm_list(vm_list)
                cloudsim.start
            # Print VM details
            broker.getVmCreatedList.each do |vm|
            puts "VM ID: #{vm.getId}, Description: #{vm.getDescription}"
            end
              end
            





        end
    end

    def self.create_datacenter( cloudsim ,datacenter)
        host_list = java.util.ArrayList.new
    
        datacenter.num_hosts.times do
          host_pe_list = java.util.ArrayList.new
          10.time do 
          host_pe_list.add(PeSimple.new(datacenter.pe_mips))
          end
          host = HostSimple.new(datacenter.ram, datacenter.bandwidth, datacenter.storage, host_pe_list)
            if ["TimeShared"].include? datacenter.scheduling_policy 
                host.set_vm_scheduler(VmSchedulerTimeShared.new)
            else 
                host.set_vm_scheduler(VmSchedulerSpaceShared.new)
            end 
            host.setRamProvisioner(ResourceProvisionerSimple.new)
            host.setBwProvisioner(ResourceProvisionerSimple.new)
          host_list.add(host)
        end
    
        characteristics = DatacenterCharacteristicsSimple.new(datacenter.cpu_cost, datacenter.ram_cost, datacenter.storage_cost, datacenter.bw_cost)

        # characteristics.set_autoscaling(autoscaling)
    
        datacenter = DatacenterSimple.new(cloudsim, host_list, VmAllocationPolicyRoundRobin.new)
        # datacenter.set_power_model(PowerModelDatacenterSimple.new(200.0, 50.0))
        datacenter.set_characteristics(characteristics)
        datacenter.set_name(datacenter.name)
    
        datacenter
    end
end
    
#     def self.run_simulation
#         cloudsim = CloudSimPlus.new
    
#         # Create a Datacenter
#         host_pe_list = java.util.ArrayList.new
#         host_pe_list.add(PeSimple.new(1000))
    
#         host = HostSimple.new(2048, 10000, 1000000, host_pe_list)
#         host.set_vm_scheduler(VmSchedulerTimeShared.new)
#         host_list = java.util.ArrayList.new
#         host_list.add(host)
    
#         characteristics = DatacenterCharacteristicsSimple.new(0.01, 0.02, 0.001, 0.005)
#         datacenter = DatacenterSimple.new(cloudsim, host_list, VmAllocationPolicyRoundRobin.new)
    
#         # Create a Broker
#         broker = DatacenterBrokerSimple.new(cloudsim, String.new("Autonomic"))
    
#         # Create a VM
#         vm_list = java.util.ArrayList.new
#         vm = VmSimple.new(1000, 1).set_ram(512).set_bw(1000).set_size(10000)
#         vm_list.add(vm)
        
#         broker.submit_vm_list(vm_list)
    
#         # Create a Cloudlet
#         cloudlet_list = java.util.ArrayList.new
#         cloudlet = CloudletSimple.new(10000, 1, UtilizationModelFull.new).set_sizes(500)
#         cloudlet_list.add(cloudlet)
#         broker.submit_cloudlet_list(cloudlet_list)

#         # Add listeners to monitor VMs and hosts
#         def add_listeners(vm_list, host_list)
#             vm_list.each do |vm|
#             vm.addOnUtilizationUpdateListener(
#                 EventListener.impl do |event|
#                 cpu_utilization = event.getVm.getCpuPercentUtilization
#                 puts "VM #{event.getVm.getId}: CPU utilization is #{cpu_utilization * 100}%."
#                 end
#             )
#             end
        
#             host_list.each do |host|
#             host.addOnUtilizationUpdateListener(
#                 EventListener.impl do |event|
#                 cpu_utilization = event.getHost.getCpuPercentUtilization
#                 puts "Host #{event.getHost.getId}: CPU utilization is #{cpu_utilization * 100}%."
#                 end
#             )
#             end
#         end
  
#   add_listeners(vm_list, datacenter.getHostList)
    
#         # Start simulation
#         cloudsim.start
    
#         # Get results
#         cloudlet_finished = broker.get_cloudlet_finished_list.get(0)
#         vm_allocated = broker.get_vm_created_list.get(0)
    
#         execution_time = cloudlet_finished.finish_time
#         cpu_util = cloudlet_finished.utilization_of_cpu
#         ram_util = cloudlet_finished.utilization_of_ram
#         bw_util = cloudlet_finished.utilization_of_bw
    
#         # Display results
#         puts "Cloudlet Execution Time: #{execution_time} seconds"
#         puts "Cloudlet CPU Utilization: #{cpu_util}"
#         puts "Cloudlet RAM Utilization: #{ram_util}"
#         puts "Cloudlet BW Utilization: #{bw_util}"
#         puts "Total CosPowerModelDatacenterSimple.newt: $#{broker.total_cost}"
    
#         # 🔥 Check SLA violations
#         check_sla_violation("CPU Utilization", cpu_util, SLA_LIMITS["cpu_utilization"])
#         check_sla_violation("RAM Utilization", ram_util, SLA_LIMITS["ram_utilization"])
#         check_sla_violation("BW Utilization", bw_util, SLA_LIMITS["bw_utilization"])
#         check_sla_violation("Execution Time", execution_time, SLA_LIMITS["execution_time"])
#     end
    
#     def self.check_sla_violation(metric, actual, limit)
#         if actual > limit
#             puts "⚠️ SLA Violation: #{metric} exceeded limit! (Actual: #{actual}, Limit: #{limit})"
#         end
#     end

    # def self.create_datacenter( datacenter)
    #     cloudsim = CloudSimPlus.new

    #     host_list = java.util.ArrayList.new
    
    #     datacenter.num_hosts.times do
    #       host_pe_list = java.util.ArrayList.new
    #       host_pe_list.add(PeSimple.new(datacenter.pe_mips))
    
    #       host = HostSimple.new(datacenter.ram, datacenter.bandwidth, datacenter.storage, host_pe_list)
    #         if ["TimeShared"].include? datacenter.scheduling_policy 
    #             host.set_vm_scheduler(VmSchedulerTimeShared.new)
    #         else 
    #             host.set_vm_scheduler(VmSchedulerSpaceShared.new)
    #         end 
    #         host.setRamProvisioner(ResourceProvisionerSimple.new)
    #         host.setBwProvisioner(ResourceProvisionerSimple.new)
    #       host_list.add(host)
    #     end
    
    #     characteristics = DatacenterCharacteristicsSimple.new(datacenter.cpu_cost, datacenter.ram_cost, datacenter.storage_cost, datacenter.bw_cost)

    #     # characteristics.set_autoscaling(autoscaling)
    
    #     datacenter = DatacenterSimple.new(cloudsim, host_list, VmAllocationPolicyRoundRobin.new)
    #     binding().pry
    #     # datacenter.set_power_model(PowerModelDatacenterSimple.new(200.0, 50.0))
    #     datacenter.set_characteristics(characteristics)
    #     datacenter.set_name(datacenter.name)
    
    #     datacenter
    # end
    
#  end
