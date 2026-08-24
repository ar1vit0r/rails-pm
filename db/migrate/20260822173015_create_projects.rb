class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.date :deadline

      t.timestamps
    end
  end
end
