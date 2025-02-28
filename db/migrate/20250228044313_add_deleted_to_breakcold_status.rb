class AddDeletedToBreakcoldStatus < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_statuses, :deleted, :boolean
    add_column :breakcold_statuses, :deleted_at, :datetime
    Breakcold::Status.parse_all_and_save
  end
end
