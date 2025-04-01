class AddWorkloadTypesInSimulation < ActiveRecord::Migration[7.1]
  def change
    add_column :simulation_results, :workload_type ,:string
    change_column :instance_types , :pricePerHour ,:float
  end
end
