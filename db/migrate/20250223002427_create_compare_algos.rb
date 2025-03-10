class CreateCompareAlgos < ActiveRecord::Migration[7.1]
  def change
    create_table :compare_algos do |t|
      t.integer :cloudlet_id
      t.string :algo
      t.float :algo_eff_time
      t.float :min_cost
      t.float :min_exec_time
      t.integer :instance_type_id
      t.integer :datacenter_id
      t.float :predicted_cost
      t.float :predicted_exec_time
      t.timestamps
    end
  end
end
