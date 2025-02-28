class AddStatusToBreakcoldLead < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_leads, :status, :jsonb, default: {}
  end
end
