class AddLabelsToPipedriveCrmPersons < ActiveRecord::Migration[7.2]
  def change
    add_column :pipedrive_people, :labels, :string
  end
end
