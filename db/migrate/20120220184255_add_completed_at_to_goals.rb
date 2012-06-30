class AddCompletedAtToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :completed_at, :date

  end
end
