class CreatePipedriveUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :pipedrive_users do |t|
      t.string :identifier
      t.text :issues
      t.jsonb :properties
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
