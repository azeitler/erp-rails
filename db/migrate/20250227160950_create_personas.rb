class CreatePersonas < ActiveRecord::Migration[7.2]
  def change
    create_table :personas do |t|
      t.string :name
      t.string :email
      t.string :linkedin

      t.timestamps
    end
  end
end
