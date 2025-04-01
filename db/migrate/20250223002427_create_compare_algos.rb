class CreateCompareAlgos < ActiveRecord::Migration[7.1]
  def change
    create_table :compare_algos do |t|
      t.integer :cloudlet_id
      t.string :algo
      t.float :algo_eff_time
      t.float :min_cost , precision: 10, scale: 2
      t.float :min_executn_time , precision: 10, scale: 2
      t.integer :instance_type_id
      t.integer :datacenter_id

      t.timestamps
    end
  end
end
