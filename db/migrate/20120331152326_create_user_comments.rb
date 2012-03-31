class CreateUserComments < ActiveRecord::Migration
  def change
    create_table :user_comments do |t|
      t.integer :task_id
      t.integer :goal_id
      t.integer :goal_user_id
      t.integer :comment_user_id
      t.text :comment
      t.integer :is_read ,    :default => 0

      t.timestamps
    end
  end
end
