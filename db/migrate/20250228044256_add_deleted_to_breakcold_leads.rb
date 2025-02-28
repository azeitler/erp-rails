class AddDeletedToBreakcoldLeads < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_leads, :deleted, :boolean
    add_column :breakcold_leads, :deleted_at, :datetime
    Breakcold::Lead.parse_all_and_save
  end
end
