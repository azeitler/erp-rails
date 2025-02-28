class AddBelongsToCampaignToLemlistLead < ActiveRecord::Migration[7.2]
  def change
    add_reference :lemlist_leads, :lemlist_campaign, null: true, foreign_key: true
  end
end
