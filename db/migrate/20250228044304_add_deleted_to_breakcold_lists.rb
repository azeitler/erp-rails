class AddDeletedToBreakcoldLists < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_lists, :deleted, :boolean
    add_column :breakcold_lists, :deleted_at, :datetime
    Breakcold::List.parse_all_and_save
  end
end
