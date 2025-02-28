class CreateJoinTableBreakcoldLeadsLists < ActiveRecord::Migration[7.2]
  def change
    create_join_table :breakcold_leads, :breakcold_lists do |t|
      # t.index [:breakcold_lead_id, :breakcold_list_id]
      # t.index [:breakcold_list_id, :breakcold_lead_id]
    end
  end
end
