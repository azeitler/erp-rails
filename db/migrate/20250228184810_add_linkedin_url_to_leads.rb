class AddLinkedinUrlToLeads < ActiveRecord::Migration[7.2]
  def change
    add_column :breakcold_leads, :linkedin_url, :string
    add_column :lemlist_leads, :linkedin_url, :string
  end
end
