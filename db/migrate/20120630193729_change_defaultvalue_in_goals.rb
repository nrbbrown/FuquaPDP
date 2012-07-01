class ChangeDefaultvalueInGoals < ActiveRecord::Migration
  def change
    change_column :goals, :is_private, :integer , :default => 0
  end
end
