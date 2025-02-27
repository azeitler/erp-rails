class AddIdentifierToLinkedinInvitation < ActiveRecord::Migration[7.2]
  def change
    add_column :linkedin_invitations, :identifier, :string
  end
end
