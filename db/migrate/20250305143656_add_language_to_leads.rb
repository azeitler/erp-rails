class AddLanguageToLeads < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_leads, :language, :string
    add_column :lemlist_leads, :language, :string
  end
end
