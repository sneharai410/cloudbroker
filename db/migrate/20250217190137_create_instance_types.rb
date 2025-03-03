class CreateInstanceTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :instance_types do |t|
      t.string :name
      t.integer :cpus
      t.integer :memoryInMB
      t.decimal :pricePerHour , precision: 10, scale: 2
      t.string :region
      t.integer :datacenter_id
      t.timestamps
    end
  end
end
