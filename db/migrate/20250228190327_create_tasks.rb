class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :job_class
      t.integer :status, default: 0, null: false
      t.text :result
      t.string :log, array: true, default: []

      t.timestamps
    end
  end
end
