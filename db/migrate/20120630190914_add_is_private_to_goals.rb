class AddIsPrivateToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :is_private, :integer

  end
end
