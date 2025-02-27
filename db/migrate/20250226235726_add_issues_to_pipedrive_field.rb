class AddIssuesToPipedriveField < ActiveRecord::Migration[7.2]
  def change
    add_column :pipedrive_fields, :issues, :text
  end
end
