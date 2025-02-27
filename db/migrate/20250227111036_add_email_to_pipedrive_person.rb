class AddEmailToPipedrivePerson < ActiveRecord::Migration[7.2]
  def change
    add_column :pipedrive_people, :email, :string
  end
end
