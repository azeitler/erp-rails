class AddOrderToBreakcoldStatus < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_statuses, :order, :integer
  end
end
