class CreateLemlistCampaigns < ActiveRecord::Migration[7.2]
  def change
    create_table :lemlist_campaigns do |t|
      t.string :identifier
      t.jsonb :properties
      t.string :title
      t.belongs_to :persona, null: true, foreign_key: true

      t.timestamps
    end
  end
end
