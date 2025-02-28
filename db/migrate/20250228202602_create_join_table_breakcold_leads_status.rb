class CreateJoinTableBreakcoldLeadsStatus < ActiveRecord::Migration[7.2]
  def change
    create_join_table :breakcold_leads, :breakcold_statuses do |t|
      # t.index [:breakcold_lead_id, :breakcold_status_id]
      # t.index [:breakcold_status_id, :breakcold_lead_id]
    end
  end
end
