class RemoveIsCommentUserReadToUserComments < ActiveRecord::Migration
  def up
    remove_column :user_comments, :is_comment_user_read
      end

  def down
    add_column :user_comments, :is_comment_user_read, :integer
  end
end
