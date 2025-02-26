class CreatePipedriveDeals < ActiveRecord::Migration[7.2]
  def change
    create_table :pipedrive_deals do |t|
      t.string :identifier
      t.text :issues
      t.jsonb :properties
      t.string :title
      t.string :pipeline
      t.string :status
      t.decimal :value
      t.datetime :close_date
      t.integer :year

      t.timestamps
    end
  end
end
