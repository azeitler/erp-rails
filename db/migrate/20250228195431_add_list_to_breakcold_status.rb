class AddListToBreakcoldStatus < ActiveRecord::Migration[7.2]
  def change
    add_reference :breakcold_statuses, :breakcold_list, null: true, foreign_key: true
  end
end
