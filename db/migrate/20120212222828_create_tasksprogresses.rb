class CreateTasksprogresses < ActiveRecord::Migration
  def change
    create_table :tasksprogresses do |t|
      t.datetime :date
      t.integer :task_id

      t.timestamps
    end
  end
end
