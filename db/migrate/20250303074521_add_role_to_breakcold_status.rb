class AddRoleToBreakcoldStatus < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_statuses, :role, :string
  end
end
