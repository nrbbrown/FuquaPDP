class AddIsPrivateFromGoals < ActiveRecord::Migration
  def change
    add_column :goals, :is_private, :integer  , :default => 0

  end
end
