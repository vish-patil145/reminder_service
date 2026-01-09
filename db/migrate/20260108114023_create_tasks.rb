class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :scheduled_at, null: false
      t.datetime :completed_at
      t.string :status, default: 'pending', null: false
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :assignee, null: false, foreign_key: { to_table: :users }
      t.boolean :reminder_sent, default: false

      t.timestamps
    end

    add_index :tasks, [ :assignee_id, :status ]
    add_index :tasks, [ :scheduled_at ]
  end
end
