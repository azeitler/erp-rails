class CreatePipedrivePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :pipedrive_people do |t|
      t.string :identifier
      t.text :issues
      t.jsonb :properties
      t.string :title

      t.timestamps
    end
  end
end
