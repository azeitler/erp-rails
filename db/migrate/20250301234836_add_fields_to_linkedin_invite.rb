class AddFieldsToLinkedinInvite < ActiveRecord::Migration[7.2]
  def change
    add_column :linkedin_invites, :properties, :jsonb
    add_column :linkedin_invites, :status_text, :string
    remove_column :linkedin_invites, :identifier
  end
end
