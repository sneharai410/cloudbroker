
#  Dir[Rails.root.join('lib', 'java', '*.jar')].each { |jar| require jar }
puts "Loading JARs from: #{Rails.root.join('lib', 'java', '*.jar')}"
$jars = Dir.glob(Rails.root.join('lib', 'java', '*.jar'))

if $jars.empty?
  puts "No JAR files found. Check the path!"
else
  puts "Found JARs: #{$jars}"
  $jars.each { |jar| require jar }
end

pry.binding

# Import CloudSim Plus classes
java_import "org.cloudsimplus.brokers.DatacenterBrokerSimple"
java_import "org.cloudsimplus.cloudlets.CloudletSimple"
java_import "org.cloudsimplus.core.CloudSimPlus"
java_import "org.cloudsimplus.datacenters.DatacenterSimple"
java_import "org.cloudsimplus.datacenters.DatacenterCharacteristicsSimple"
java_import "org.cloudsimplus.hosts.HostSimple"
java_import "org.cloudsimplus.provisioners.ResourceProvisionerSimple"
java_import "org.cloudsimplus.resources.PeSimple"
java_import "org.cloudsimplus.schedulers.cloudlet.CloudletSchedulerTimeShared"
java_import "org.cloudsimplus.schedulers.vm.VmSchedulerTimeShared"
java_import "org.cloudsimplus.utilizationmodels.UtilizationModelFull"
java_import "org.cloudsimplus.vms.VmSimple"


  
class SimulationJob < ApplicationJob
   def perform
    # Initialize CloudSim Plus
    cloudsim = CloudSimPlus.new

    # Create a Datacenter
    host_pe_list = java.util.ArrayList.new
    host_pe_list.add(PeSimple.new(1000)) # 1 PE with 1000 MIPS capacity

    ram = 2048 # 2 GB
    bw = 10000 # 10 Gbps
    storage = 1000000 # 1 TB
    host = HostSimple.new(ram, bw, storage, host_pe_list)
    host.set_vm_scheduler(VmSchedulerTimeShared.new)

    host_list = java.util.ArrayList.new
    host_list.add(host)

    characteristics = DatacenterCharacteristicsSimple.new(host_list)
    datacenter = DatacenterSimple.new(cloudsim, characteristics)

    # Create a Broker
    broker = DatacenterBrokerSimple.new(cloudsim)

    # Create a VM
    vm = VmSimple.new(1000, 1) # 1000 MIPS, 1 CPU core
    vm.set_ram(512).set_bw(1000).set_size(10000) # 512 MB RAM, 1 Gbps BW, 10 GB storage
    broker.submit_vm_list([vm])

    # Create a Cloudlet
    utilization_model = UtilizationModelFull.new
    cloudlet = CloudletSimple.new(10000, 1, utilization_model) # 10000 MI, 1 PE
    cloudlet.set_sizes(500) # 500 MB
    broker.submit_cloudlet_list([cloudlet])

    # Start the simulation
    cloudsim.start

    # Generate a report
    cloudlet_finished = broker.get_cloudlet_finished_list.get(0)
    vm_allocated = broker.get_vm_created_list.get(0)

    puts "Cloudlet ID: #{cloudlet_finished.id}"
    puts "Cloudlet Status: #{cloudlet_finished.status}"
    puts "Cloudlet Execution Time: #{cloudlet_finished.finish_time} seconds"
    puts "Cloudlet CPU Utilization: #{cloudlet_finished.utilization_of_cpu}"
    puts "Cloudlet RAM Utilization: #{cloudlet_finished.utilization_of_ram}"
    puts "Cloudlet BW Utilization: #{cloudlet_finished.utilization_of_bw}"

    puts "VM ID: #{vm_allocated.id}"
    puts "VM CPU Utilization: #{vm_allocated.cpu_utilization}"
    puts "VM RAM Utilization: #{vm_allocated.ram_utilization}"
    puts "VM BW Utilization: #{vm_allocated.bw_utilization}"

    puts "Total Cost: $#{broker.total_cost}"

    # Do something later
  end
end