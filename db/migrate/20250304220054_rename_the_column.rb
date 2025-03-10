class RenameTheColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :simulation_results , :sla_breach_cost , :vm_exec_cost
  end
end
