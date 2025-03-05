class CreateJoinTableBreakcoldLeadsLemlistLeads < ActiveRecord::Migration[7.2]
  def change
    create_join_table :breakcold_leads, :lemlist_leads do |t|
      t.index [:breakcold_lead_id, :lemlist_lead_id]
      # t.index [:lemlist_lead_id, :breakcold_lead_id]
    end
  end
end
