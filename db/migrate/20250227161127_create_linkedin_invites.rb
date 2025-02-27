class CreateLinkedinInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :linkedin_invites do |t|
      t.integer :from_persona_id
      t.string :name
      t.string :linkedin_url
      t.datetime :accepted_at
      t.string :status

      t.timestamps
    end
  end
end
