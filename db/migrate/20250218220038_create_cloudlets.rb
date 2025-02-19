class CreateCloudlets < ActiveRecord::Migration[7.1]
  def change
    create_table :cloudlets do |t|
      t.integer :length
      t.integer :file_size
      t.integer :output_size
      t.string :workload_type

      t.timestamps
    end
  end
end
