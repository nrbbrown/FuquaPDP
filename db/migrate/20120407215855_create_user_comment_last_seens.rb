class CreateUserCommentLastSeens < ActiveRecord::Migration
  def change
    create_table :user_comment_last_seen do |t|
      t.integer :task_id 
	  t.integer :goal_id
	  t.integer :user_id
      t.datetime :last_seen
    end
  end
end
