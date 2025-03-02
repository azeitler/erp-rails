class AddAliasToPersona < ActiveRecord::Migration[7.2]
  def change
    add_column :personas, :alias, :string
  end
end
