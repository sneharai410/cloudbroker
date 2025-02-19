class CreateDatacenters < ActiveRecord::Migration[7.1]
  def change
    create_table :datacenters do |t|
      t.string  :name, null: false
      t.integer :num_hosts, default: 1
      t.integer :pe_mips, default: 1000
      t.integer :ram, default: 8192
      t.integer :storage, default: 1000000
      t.integer :bandwidth, default: 10000
      t.string  :scheduling_policy, default: "TimeShared"
      t.string  :power_model, default: "PowerAware"
      t.integer :latency, default: 10
      t.string  :topology, default: "Mesh"
      t.string  :bandwidth_policy, default: "Best Effort"
      t.string  :storage_type, default: "SSD"
      t.float :cpu_cost, default: 0.05
      t.float :ram_cost, default: 0.01
      t.float :storage_cost, default: 0.001
      t.float :bw_cost, default: 0.005
      t.float :power_usage, default: 200
      t.float :idle_power, default: 50
      t.boolean :autoscaling, default: false
      t.timestamps
    end
  end
end
