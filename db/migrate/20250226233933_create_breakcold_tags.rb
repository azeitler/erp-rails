class CreateBreakcoldTags < ActiveRecord::Migration[7.2]
  def change
    create_table :breakcold_tags do |t|
      t.string :identifier
      t.jsonb :properties
      t.string :title

      t.timestamps
    end
  end
end
