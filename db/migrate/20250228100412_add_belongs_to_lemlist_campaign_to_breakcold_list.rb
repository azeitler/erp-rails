class AddBelongsToLemlistCampaignToBreakcoldList < ActiveRecord::Migration[7.2]
  def change
    add_reference :breakcold_lists, :lemlist_campaign, null: true, foreign_key: true
  end
end
