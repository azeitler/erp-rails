class AddTypeToBreakcoldLead < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_leads, :type, :string
  end
end
