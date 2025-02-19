class CreateInstanceTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :instance_types do |t|
      t.string :name
      t.integer :cpus
      t.integer :memoryInMb
      t.decimal :pricePerHour
      t.string :region

      t.timestamps
    end
  end
end
