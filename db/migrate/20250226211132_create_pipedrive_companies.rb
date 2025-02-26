class CreatePipedriveCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :pipedrive_companies do |t|
      t.string :identifier
      t.text :issues
      t.jsonb :properties
      t.string :title
      t.string :customer_number

      t.timestamps
    end
  end
end
