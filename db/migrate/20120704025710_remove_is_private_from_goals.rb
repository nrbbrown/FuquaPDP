class RemoveIsPrivateFromGoals < ActiveRecord::Migration
  def up
    remove_column :goals, :is_private
      end

  def down
    add_column :goals, :is_private, :integer
  end
end
