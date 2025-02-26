class CreateBreakcoldLeads < ActiveRecord::Migration[7.2]
  def change
    create_table :breakcold_leads do |t|
      t.string :identifier
      t.jsonb :properties
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
