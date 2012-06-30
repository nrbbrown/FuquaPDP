class AddIsCommentUserReadToUserComments < ActiveRecord::Migration
  def change
    add_column :user_comments, :is_comment_user_read, :integer

  end
end
