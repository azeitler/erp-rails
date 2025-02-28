class CreateBreakcoldLeadActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :breakcold_lead_activities do |t|
      t.string :title
      t.belongs_to :breakcold_lead, null: false, foreign_key: true

      t.timestamps
    end
  end
end
