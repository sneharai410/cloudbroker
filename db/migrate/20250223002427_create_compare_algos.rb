class CreateCompareAlgos < ActiveRecord::Migration[7.1]
  def change
    create_table :compare_algos do |t|
      t.integer :cloudlet_id
      t.string :algo
      t.decimal :algo_eff_time
      t.decimal :min_cost
      t.decimal :min_executn_time
      t.integer :instance_type_id
      t.integer :datacenter_id

      t.timestamps
    end
  end
end
