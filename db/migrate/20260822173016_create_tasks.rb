class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.integer :priority
      t.date :due_date

      t.timestamps
    end
  end
end
