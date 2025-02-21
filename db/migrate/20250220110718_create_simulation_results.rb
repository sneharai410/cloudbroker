class CreateSimulationResults < ActiveRecord::Migration[7.1]
  def change
    create_table :simulation_results do |t|
      t.integer :datacenter_id
      t.string :datacenter_name
      t.float :datacenter_cpu_cost
      t.float :datacenter_ram_cost
      t.float :datacenter_storage_cost
      t.float :datacenter_bw_cost
      t.integer :host_id
      t.integer :host_cpu_cores
      t.integer :host_ram
      t.integer :host_storage
      t.integer :host_bw
      t.float :host_mips
      t.integer :vm_id
      t.integer :vm_cpu_cores
      t.integer :vm_ram
      t.integer :vm_storage
      t.integer :vm_bw
      t.float :vm_mips
      t.integer :cloudlet_id
      t.integer :cloudlet_length
      t.integer :cloudlet_pes
      t.integer :cloudlet_file_size
      t.integer :cloudlet_output_size
      t.float :execution_time
      t.float :cpu_utilization
      t.float :ram_utilization
      t.float :bw_utilization
      t.float :storage_utilization
      t.boolean :execution_time_breach
      t.boolean :cpu_breach
      t.boolean :ram_breach
      t.boolean :bw_breach
      t.float :cost
      t.float :sla_breach_cost
      t.timestamps
    end
  end
end
