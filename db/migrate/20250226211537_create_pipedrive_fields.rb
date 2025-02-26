class CreatePipedriveFields < ActiveRecord::Migration[7.2]
  def change
    create_table :pipedrive_fields do |t|
      t.string :identifier
      t.jsonb :properties
      t.string :title
      t.string :field_level
      t.string :field_name
      t.string :field_target
      t.string :field_type
      t.jsonb :values

      t.timestamps
    end
  end
end
