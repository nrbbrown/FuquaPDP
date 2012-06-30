class CreateUserLastSeenComments < ActiveRecord::Migration
  def change
    create_table :user_last_seen_comments do |t|
      t.integer :goal_id
      t.integer :task_id
      t.integer :user_id
      t.datetime :last_seen
    end
  end
end
